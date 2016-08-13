require 'zip'

class Problem < ActiveRecord::Base
  SUPPORTED_LANGUAGES = %w(
    c
    c_plus_plus
    java
    python
    ruby
  )

  # allow multiple compilers in future by passing a param to docker container for version
  # make sure when deploying to production machines have the matching version of compilers
  LANGUAGE_VERSION_MAP = {
    c: 'gcc 5.3',
    c_plus_plus: 'g++ 5.3',
    java: '1.8',
    python: '2.7',
    ruby: '2.3'
  }.with_indifferent_access

  TIME_LIMIT_RANGE = (1..60).to_a

  has_many :assignment_problems
  has_many :assignments, through: :assignment_problems
  has_many :test_cases
  belongs_to :owner, class_name: :User
  attr_accessor :code

  validates_presence_of :name, :owner, :statement
  validates :time_limit, inclusion: { within: TIME_LIMIT_RANGE, message: "must be between 1-60 seconds"  }

  scope :owned_by, -> (user) { where(owner: user) }

  def upload_input_files(input_files_params)
    update_attributes(input_files_uploaded_at: nil)
    InputFileUploader.new(problem_id: id, zip_inputs_path: input_files_params[:input_files].path).commit
    touch(:input_files_uploaded_at)
  end

  def generate_outputs(output_options)
    return false if output_options[:code].blank? || output_options[:language].blank?
    update_attributes(outputs_generated_at: nil, outputs_generation_in_progress: true)
    byebug
    OutputGenerator.create(output_options.merge(problem_id: id, time_limit: time_limit)).commit
  end

  def set_output_generation(output_results)
    touch :outputs_generated_at if output_results.all? { |result| result[:status].eql?('OK') }
    self.outputs_generation_in_progress = false
    add_outputs_generation_info(output_results)
  end

  private def add_outputs_generation_info(output_results)
    self.outputs_generation_info = output_results.map do |result|
      "input: #{result[:input_file]} status: #{result[:status]}"
    end.join(", ")

    save!
  end

  private def input_file_uploader
    @input_file_uploader ||= InputFileUploader.new(problem_id: id, zip_inputs_path: input_files_params[:input_files].path)
  end
end
