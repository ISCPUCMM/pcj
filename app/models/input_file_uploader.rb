class InputFileUploader < Task
  attr_accessor :zip_inputs_path
  validates_presence_of :problem_id, :zip_inputs_path

  after_initialize :create_tmp_directory

  def commit
    destroy_existing_files
    upload_inputs
  ensure
    FileUtils.remove_entry_secure tmp_directory
  end

  private def destroy_existing_files
    input_file_keys.each do |key|
      s3.delete_object(bucket: 'pcj-problem-inputs', key: key)
    end

    problem.test_cases.destroy_all
  end

  private def upload_inputs
    Zip::File.open(zip_inputs_path) do |zip_file|
      zip_file.reject { |entry| entry.name =~ /__MACOSX/ or entry.name =~ /\.DS_Store/ or !entry.file? }.each_with_index do |entry, idx|
        dest_file = "#{tmp_directory}/#{idx}.in"
        entry.extract(dest_file)

        test_case = TestCase.create!(tc_index: idx, problem: problem)
        upload_input(dest_file: dest_file, key: test_case.s3_input_key)
      end
    end
  end

  private def upload_input(dest_file:, key:)
    File.open(dest_file, 'rb') do |file|
      s3.put_object(bucket: 'pcj-problem-inputs', key: key, body: file)
    end
  end
end
