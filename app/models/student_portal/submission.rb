class StudentPortal::Submission < ActiveRecord::Base
  belongs_to :problem_solution, class_name: 'StudentPortal::ProblemSolution'

  enum status: { pending: 0, accepted: 1, wa: 2, error: 3 }
  after_create :upload_submission
  after_create :grade

  attr_accessor :code

  private def key
    "#{problem_solution.user_id}/#{id}"
  end

  private def upload_submission
    Aws::S3::Client.new.put_object(bucket: 'pcj-user-submissions', key: key, body: code)
  end

  private def grade
  end
end
