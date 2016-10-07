class TestGroupResult
  attr_reader :test_group, :test_results

  delegate :weight, to: :test_group
  delegate :<<, :push, to: :test_results

  def initialize(test_group:)
    @test_group = test_group
    @test_results = []
  end

  def status_info
    @status ||= accepted? ? pass_info : failure_info
  end


  def accepted?
    test_results.all?(&:accepted?)
  end

  private def pass_info
    { status: 'AC', test: test_results.last.tc_index+1 }
  end

  private def failure_info
    first_failure = test_results.find { |tr| !tr.accepted? }

    { status: first_failure.status, test_num: first_failure.tc_index + 1 }
  end
end
