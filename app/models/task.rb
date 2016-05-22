class Task < ActiveRecord::Base
  attr_accessor :code, :input, :uuid
  attr_reader :tmp_directory

  after_initialize :initialize_uuid

  def run
    create_tmp_directory
    prepare_files_for_processing
    run_code
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

  private def run_code
    system "docker run -m 200M -v #{tmp_directory}/:/submitted_code --rm judge ruby code_runner/run.rb --pl=#{language} --limit=#{time_limit} --uuid=#{uuid}"
  end

  private def create_tmp_directory
    #when on linux machine
    #@tmp_directory = Dir.mktmpdir

    #TEMPORARY HACK NEEDED ON MAC

    @tmp_directory = Dir.mktmpdir(nil, '/Users/mpgaillard/Dropbox/proyecto_final/judge/tmp/code_to_execute/')
  end

  private def output_hash
    status = File.read("#{tmp_directory}/#{uuid}.status")

    {
      status: status,
      output: status.eql?('OK') ? File.read("#{tmp_directory}/#{uuid}.out") : ''
    }
  end
end
