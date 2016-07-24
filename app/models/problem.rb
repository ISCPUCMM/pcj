require 'zip'

class Problem < ActiveRecord::Base
  SUPPORTED_LANGUAGES = %w(
    c
    c_plus_plus
    java
    python
    ruby
  )

  has_many :assignment_problems
  has_many :assignments, through: :assignment_problems
  attr_accessor :code, :tmp_directory, :input_file_keys#use task model
  belongs_to :owner, class_name: :User

  validates_presence_of :name, :owner

  scope :owned_by, -> (user) { where(owner: user) }

  def upload_input_files(input_files_params)
    update_attributes(input_files_uploaded_at: nil)
    InputFileUploader.new(problem_id: id, zip_inputs_path: input_files_params[:input_files].path).commit
    touch(:input_files_uploaded_at)
  end

  def generate_outputs(output_options)
    return false if output_options[:code].blank? || output_options[:language].blank?
    update_attributes(outputs_generated_at: nil)
    OutputGenerator.create(output_options.merge(problem_id: id, time_limit: 2)).commit
  end

  def set_output_generation(output_results)
    touch :outputs_generated_at if output_results.all? { |result| result[:status].eql?('OK') }
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
