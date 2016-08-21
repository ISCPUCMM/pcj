class StudentPortal::Submission < ActiveRecord::Base
  belongs_to :problem_solution, class_name: 'StudentPortal::ProblemSolution'

  enum status: { pending: 0, accepted: 1, wa: 2, tle: 3, error: 4 }
  after_create :upload_submission
  after_create :grade

  attr_accessor :code

  delegate :course, :assignment, :problem, to: :problem_solution


  scope :course_assignment_submissions_for, -> (course, assignment) do
    joins(:problem_solution)
      .where(student_portal_problem_solutions: { course_id: course, assignment_id: assignment })
  end

  scope :course_assignment_user_submissions_for, -> (course, assignment, user) do
    course_assignment_submissions_for(course, assignment)
      .where(student_portal_problem_solutions: { user_id: user })
  end

  scope :course_assignment_problem_user_submissions_for, -> (course, assignment, problem, user) do
    course_assignment_user_submissions_for(course, assignment, user)
      .where(student_portal_problem_solutions: { problem_id: problem })
  end

  scope :most_recent, -> do
    order(created_at: :desc)
  end

  def valid_submission?
    created_at.between?(assignment.starts_at, assignment.ends_at)
  end

  def key
    "#{problem_solution.user_id}/#{id}"
  end

  private def upload_submission
    Aws::S3::Client.new.put_object(bucket: 'pcj-user-submissions', key: key, body: code)
  end

  private def grade
    test_results = Grader.create!(submission: self,
                                  problem: problem,
                                  time_limit: problem.time_limit,
                                  language: language).commit
    byebug
  end
  handle_asynchronously :grade

end
