class TestResult
  attr_reader :test_case, :status, :accepted

  delegate :index, to: :test_case

  def initialize(test_case:, status:, accepted:)
    @test_case = test_case
    @status = status
    @accepted = accepted
  end
end
