class OutputGenerator < Task
  attr_accessor :code
  validates_presence_of :problem_id, :code, :language

  def commit
    prepare_files_for_processing
    build_outputs
  ensure
    FileUtils.remove_entry_secure tmp_directory
  end
  #handle_asynchronously :commit, queue => 'tasks'

  #fix this ugly method, consider a separate class runner for each output
  private def build_outputs
    input_file_keys.map do |key|
      move_input_file(path: "#{input_files_directory}#{key}")
      run_code
      # return status if !status.eql?('OK')
      upload_output(output_key: key.gsub('.in', '.out')) if status.eql?('OK')
      { input_file: key, status: status }
    end
  end

  private def upload_output(output_key:)
    File.open(output_file_location, 'rb') do |file|
      s3.put_object(bucket: 'pcj-problem-outputs', key: output_key, body: file)
    end
  end

  private def prepare_files_for_processing
    create_tmp_directory
    download_input_files
    create_code_file(target_code: code)
  end
end
