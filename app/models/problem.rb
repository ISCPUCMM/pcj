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

  #CREATE NEW TASK MODEL. THAT'S WHERE ALL S3 WORK SHOULD BE DONE
  def upload_input_files(input_files_params)
    update_attributes(input_files_uploaded_at: nil)
    destroy_existing_files

    zip_path = input_files_params[:input_files].path

    Zip::File.open(zip_path) do |zip_file|
      zip_file.reject { |entry| entry.name =~ /__MACOSX/ or entry.name =~ /\.DS_Store/ or !entry.file? }.each_with_index do |entry, idx|
        create_tmp_directory
        dest_file = "#{tmp_directory}/#{idx}.in"
        entry.extract(dest_file)
        upload_input(dest_file: dest_file, key: "#{id}/#{idx}.in")
      end
    end

    touch(:input_files_uploaded_at)
  ensure
    FileUtils.remove_entry_secure tmp_directory
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

  private def input_file_keys
    @input_file_keys ||= s3.list_objects(bucket: 'pcj-problem-inputs', prefix: "#{id}/")
      .contents.map(&:key).reject{ |key| key.eql?("#{id}/") }.to_set
  end

  private def add_outputs_generation_info(output_results)
    self.outputs_generation_info = output_results.map do |result|
      "input: #{result[:input_file]} status: #{result[:status]}"
    end.join(", ")

    save!
  end

  private def destroy_existing_files
    input_file_keys.each do |key|
      s3.delete_object(bucket: 'pcj-problem-inputs', key: key)
    end
  end

  private def create_tmp_directory
    @tmp_directory = Dir.mktmpdir
  end

  private def upload_input(dest_file:, key:)
    File.open(dest_file, 'rb') do |file|
      s3.put_object(bucket: 'pcj-problem-inputs', key: key, body: file)
    end
  end

  private def input_key_for(file_name)
    "#{problem.id}/#{file_name}"
  end

  private def s3
    @s3 ||= Aws::S3::Client.new
  end
end
