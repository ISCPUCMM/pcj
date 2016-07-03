class Grader < Task

  validates_presence_of :file_key, :submission_id, :problem_id

  def commit
    prepare_files_for_processing
  ensure
    FileUtils.remove_entry_secure tmp_directory
  end
  #handle_asynchronously :commit, queue => 'tasks'

  private def prepare_files_for_processing
    create_tmp_directory
    download_input_files #change to find_or_download in the future
    download_submission
    byebug
  end

  private def download_submission
    File.open(code_file_location, 'wb') do |file|
      reap = s3.get_object({ bucket:'pcj-user-submissions', key: file_key }, target: file)
    end
  end
end
