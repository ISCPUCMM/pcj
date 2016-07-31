module ProblemsHelper

  def language_selection_options
    Problem::SUPPORTED_LANGUAGES.map do |language|
      if language.eql? 'c_plus_plus'
        { value: language, text: 'C++'}
      else
        { value: language, text: language.humanize }
      end
    end
  end

  def tc_input_file_row_text_for(test_case)
    "#{test_case.tc_index}.in"
  end

  def tc_output_file_row_text_for(test_case)
    "#{test_case.tc_index}.in"
  end
end
