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
end
