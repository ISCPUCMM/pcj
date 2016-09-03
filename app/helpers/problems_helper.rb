module ProblemsHelper

  def language_selection_options
    Problem::SUPPORTED_LANGUAGES.map do |language|
      if language.eql? 'c_plus_plus'
        { value: language, text: "C++ (#{Problem::LANGUAGE_VERSION_MAP[language]})"}
      else
        { value: language, text: "#{language.humanize} (#{Problem::LANGUAGE_VERSION_MAP[language]})"}
      end
    end
  end

  def tc_input_file_row_text_for(test_case)
    "#{test_case.tc_index}.in"
  end

  def tc_output_file_row_text_for(test_case)
    "#{test_case.tc_index}.out"
  end

  def time_limit_select
    Problem::TIME_LIMIT_RANGE.map { |t_l| ["#{t_l}s", t_l] }
  end

  def test_case_weight_range
    TestCase::WEIGHT_RANGE
  end
end
