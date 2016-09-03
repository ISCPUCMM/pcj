require 'output_checker'
require 'test_result'

class Grader < Task
  belongs_to :submission, class_name: 'StudentPortal::Submission'
  belongs_to :problem

  validates_presence_of :submission, :problem, :time_limit, :language

  def commit
    prepare_files_for_processing
    compare_outputs
  ensure
    FileUtils.remove_entry_secure tmp_directory
  end
  #handle_asynchronously :commit, queue => 'tasks'

  #refactor some of this download input/output file stuff
  private def create_output_files_directory
    Dir.mkdir output_files_directory
    Dir.mkdir "#{output_files_directory}/#{problem_id}"
  end

  private def output_files_directory
    "#{tmp_directory}/output_files/"
  end

  private def download_output_files
    create_output_files_directory
    output_file_keys.each do |key|
      s3.get_object({ bucket:'pcj-problem-outputs', key: key }, target: "#{output_files_directory}#{key}")
    end
  end

  private def output_file_keys
    @output_file_keys ||= s3.list_objects(bucket: 'pcj-problem-outputs', prefix: "#{problem_id}/")
      .contents.map(&:key).reject{ |key| key.eql?("#{problem_id}/") }.to_set
  end

  private def prepare_files_for_processing
    create_tmp_directory
    download_submission
    download_input_files #change all of these to find_or_download in the future(store local copies in temp)
    download_output_files
  end

  private def compare_outputs
    problem.test_cases.map do |test_case|
      move_input_file(path: "#{input_files_directory}#{test_case.s3_input_key}")
      output_key = test_case.s3_output_key
      run_code

      TestResult.new(
        status: status,
        test_case: test_case,
        accepted: status.eql?('OK') && OutputChecker.new(student_output: output_file_location, professor_output: "#{output_files_directory}#{output_key}").valid_output?
      )
    end
  end

  private def download_submission
    File.open(code_file_location, 'wb') do |file|
      reap = s3.get_object({ bucket:'pcj-user-submissions', key: submission.key }, target: file)
    end
  end
end
