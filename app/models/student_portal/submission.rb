class StudentPortal::Submission < ActiveRecord::Base
  belongs_to :problem_solution, class_name: 'StudentPortal::ProblemSolution'

  enum status: { pending: 0, accepted: 1, wa: 2, tle: 3, error: 4 }

  after_create :upload_submission
  after_create :calculate_grade

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

  private def run_tests
    Grader.create!(submission: self,
                   problem: problem,
                   time_limit: problem.time_limit,
                   language: language).commit
  end

  private def update_problem_solution
    # if valid_submission? && !problem_solution.accepted?
    #   problem_solution.status = status
    # end
  end

  private def set_status(test_result)
    case test_result.status
    when 'OK'
      self.info = "WA test #{test_result.tc_index + 1}"
      wa!
    when 'Compilation Error', 'Runtime Error'
      self.info = "#{test_result.status} test #{test_result.tc_index + 1}"
      error!
    when 'Time Limit Exceeded'
      self.info = "#{test_result.status} test #{test_result.tc_index + 1}"
      tle!
    end
  end

  private def calculate_grade
    test_results = run_tests

    # This ugly logic is temporary
    if test_results.map(&:accepted).all?
      self.accepted!
      self.info = 'OK'
    else
      test_results.each do |test_result|
        if !test_result.accepted
          set_status(test_result)
          break
        end
      end
    end

    if valid_submission?
      self.grade = (Float(test_results.select(&:accepted).count)/test_results.count)*100.0
      update_problem_solution
    else
      self.grade = 0
    end

    save!
  end
  handle_asynchronously :calculate_grade

end
