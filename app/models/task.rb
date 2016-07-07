class Task < ActiveRecord::Base
  attr_accessor :uuid, :code, :input
  attr_reader :tmp_directory

  validates_presence_of :time_limit, :language

  def commit
    raise NotImplementedError, 'must implement this method'
  end

  private def prepare_files_for_processing
    raise NotImplementedError, 'must implement this method'
  end

  private def uuid
    @uuid ||= SecureRandom.uuid
  end

  private def s3
    @s3 ||= Aws::S3::Client.new
  end

  private def create_tmp_directory
    #when on linux machine
    #@tmp_directory = Dir.mktmpdir

    #TEMPORARY HACK NEEDED ON MAC

    @tmp_directory = Dir.mktmpdir(nil, '/Users/mpgaillard/Dropbox/proyecto_final/judge/tmp/code_to_execute/')
  end

  private def code_file_location
    "#{tmp_directory}/#{uuid}.code"
  end

  private def input_file_location
    "#{tmp_directory}/#{uuid}.in"
  end

  private def output_file_location
    "#{tmp_directory}/#{uuid}.out"
  end

  private def checker_file_location
    "#{tmp_directory}/#{uuid}.checker"
  end

  private def create_input_file(target_input:)
    File.open(input_file_location, 'w'){ |file| file.write target_input }
  end

  private def create_code_file(target_code:)
    File.open(code_file_location, 'w'){ |file| file.write target_code }
  end

  private def status
    File.read("#{tmp_directory}/#{uuid}.status")
  end

  private def create_input_files_directory
    Dir.mkdir input_files_directory
    Dir.mkdir "#{input_files_directory}/#{problem_id}"
  end

  private def input_files_directory
    "#{tmp_directory}/input_files/"
  end

  private def download_input_files
    create_input_files_directory
    input_file_keys.each do |key|
      s3.get_object({ bucket:'pcj-problem-inputs', key: key }, target: "#{input_files_directory}#{key}")
    end
  end

  private def input_file_keys
    @input_file_keys ||= s3.list_objects(bucket: 'pcj-problem-inputs', prefix: "#{problem_id}/")
      .contents.map(&:key).reject{ |key| key.eql?("#{problem_id}/") }.to_set
  end

  private def move_input_file(path:)
    FileUtils.mv(path, input_file_location)
  end

  private def run_code
    system "docker run -m 200M -v #{tmp_directory}/:/submitted_code --rm judge ruby code_runner/run.rb --pl=#{language} --limit=#{time_limit} --uuid=#{uuid}"
  end
end
