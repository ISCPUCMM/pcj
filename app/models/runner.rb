class Runner < Task
  validates_presence_of :code, :language, :time_limit

  def commit
    prepare_files_for_processing
    run_code
    output_hash
  ensure
    FileUtils.remove_entry_secure tmp_directory
  end

  private def prepare_files_for_processing
    create_tmp_directory
    create_input_file(target_input: input)
    create_code_file(target_code: code)
  end

  private def output_hash
    {
      status: status,
      output: status.eql?('OK') ? File.read("#{tmp_directory}/#{uuid}.out") : ''
    }
  end
end
