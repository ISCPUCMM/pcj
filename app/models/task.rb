class Task < ActiveRecord::Base
  attr_accessor :code, :input, :uuid
  attr_reader :tmp_directory

  after_initialize :initialize_uuid

  def run
    create_tmp_directory
    prepare_files_for_processing
    # run_container
    output_hash
  ensure
    FileUtils.remove_entry_secure tmp_directory
  end

  def judge
  end

  private def initialize_uuid
    @uuid = SecureRandom.uuid
  end

  private def prepare_files_for_processing
    create_input_file
    create_code_file
  end

  private def create_input_file
    File.open("#{tmp_directory}/#{uuid}.in", 'w'){ |file| file.write input }
  end

  private def create_code_file
    File.open("#{tmp_directory}/#{uuid}.code", 'w'){ |file| file.write code }
  end

  private def create_tmp_directory
    @tmp_directory = Dir.mktmpdir
  end

  private def output_hash
    { output: File.read("{tmp_directory}/#{uuid}.out") }
  end
end
