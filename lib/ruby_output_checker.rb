class RubyOutputChecker < OutputChecker
  #pass version parameter in the future here and in the docker runner
  def valid_output?
    system("ruby #{checker_file_location} --student_out=#{student_output} --professor_out=#{professor_output}")
  end
end
