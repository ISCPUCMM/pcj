class OutputChecker
  attr_reader :student_output, :professor_output

  def initialize(student_output:, professor_output:)
    @student_output = student_output
    @professor_output = professor_output
  end

  def valid_output?
    system("diff #{student_output} #{professor_output} -b -B")
  end
end
