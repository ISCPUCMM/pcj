class PolygonUploader < Task
  attr_accessor :zip_folder_path, :owner
  validates_presence_of :zip_folder_path

  after_initialize :create_tmp_directory

  def commit
    extract_all
    # create_problem
    # upload_inputs
  ensure
    FileUtils.remove_entry_secure tmp_directory
  end

  private def extract_all
    Zip::File.open(zip_folder_path) do |zip_file|
      #we might have further exceptions
      klean_files = zip_file.reject { |entry| entry.name =~ /__MACOSX/ or entry.name =~ /\.DS_Store/ or !entry.file? }
      extract_problem_info(klean_files)
      extract_problem_properties(klean_files)
      create_problem

    # Zip::File.open(zip_inputs_path) do |zip_file|
    #   zip_file.reject { |entry| entry.name =~ /__MACOSX/ or entry.name =~ /\.DS_Store/ or !entry.file? }.each_with_index do |entry, idx|
    #     dest_file = "#{tmp_directory}/#{idx}.in"
    #     entry.extract(dest_file)

    #     test_case = TestCase.create!(tc_index: idx, problem: problem)
    #     upload_input(dest_file: dest_file, key: test_case.s3_input_key)
    #   end
    # end
    end
  end

  private def create_problem
    self.problem_id = Problem.create!(
      owner: owner,
      name: problem_properties['name'],
      statement: problem_properties['legend'],
      input_format: problem_properties['input'],
      output_format: problem_properties['output'],
      examples: problem_properties['sampleTests'].map { |test| "input:\n#{test['input']}\noutput:\n#{test['output']}" }.join("\n"),
      notes: problem_properties['notes'],
      time_limit: (Float(problem_properties['timeLimit'])/1000).ceil
    ).id

    save!
  end

  private def problem_info_path
    "#{tmp_directory}/problem_info.xml"
  end

  private def problem_properties_path
    "#{tmp_directory}/problem-properties.json"
  end

  private def extract_problem_info(klean_files)
    klean_files.select { |entry| entry.name =~ /[^\\]\/problem\.xml$/ }.first.extract(problem_info_path)
  end

  private def extract_problem_properties(klean_files)
    klean_files.select { |entry| entry.name =~ /problem-properties\.json$/ }.first.extract(problem_properties_path)
  end

  private def problem_properties
    @problem_properties ||= JSON.parse(File.read(problem_properties_path))
  end

  private def problem_info
    @problem_info ||= Nokogiri::XML(File.read(problem_info_path))
  end

  # private def upload_input(dest_file:, key:)
  #   File.open(dest_file, 'rb') do |file|
  #     s3.put_object(bucket: 'pcj-problem-inputs', key: key, body: file)
  #   end
  # end
end
