class TestResult
  attr_reader :test_case, :status, :accepted

  delegate :tc_index, to: :test_case

  def initialize(test_case:, status:, accepted:)
    @test_case = test_case
    @status = status
    @accepted = accepted
  end

  def accepted?
    accepted
  end
end
