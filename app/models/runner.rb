class Runner < Task
  validates_presence_of :code, :language

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

  # private def input_file_location
  #   "#{tmp_directory}/#{uuid}.in"
  # end

  # private def create_input_file
  #   File.open(input_file_location, 'w'){ |file| file.write input }
  # end

  # private def create_code_file
  #   File.open(code_file_location, 'w'){ |file| file.write code }
  # end

  # private def run_code
  #   system "docker run -m 200M -v #{tmp_directory}/:/submitted_code --rm judge ruby code_runner/run.rb --pl=#{language} --limit=#{time_limit} --uuid=#{uuid}"
  # end

  private def output_hash
    {
      status: status,
      output: status.eql?('OK') ? File.read("#{tmp_directory}/#{uuid}.out") : ''
    }
  end
end
