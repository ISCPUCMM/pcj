class StudentPortal::Submission < ActiveRecord::Base
  include ProblemStatus

  belongs_to :problem_solution, class_name: 'StudentPortal::ProblemSolution'

  after_create :upload_submission
  after_create :calculate_grade

  attr_accessor :code

  delegate :course, :assignment, :problem, :user, to: :problem_solution


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

  def submission_url
    Aws::S3::Object.new('pcj-user-submissions', key).presigned_url(:get, expires_in: 1.minute)
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
    if valid_submission? && !problem_solution.accepted? && grade >= problem_solution.grade
      problem_solution.update_attributes(status: status, grade: grade)
    end
  end

  private def set_status(status_info)
    case status_info[:status]
    when 'AC'
      accepted!
    when 'OK'
      self.info = "WA test #{status_info[:test_num]}"
      wa!
    when 'Compilation Error', 'Runtime Error'
      self.info = "#{status_info[:status]} test #{status_info[:test_num]}"
      error!
    when 'Time Limit Exceeded'
      self.info = "#{status_info[:status]} test #{status_info[:test_num]}"
      tle!
    end
  end

  private def calculate_grade
    test_groups = run_tests

    failed_group = test_groups.find { |tg| !tg.accepted? }

    if failed_group.present?
      set_status failed_group.status_info
    else
      set_status test_groups.first.status_info
    end

    if valid_submission?
      denom = test_groups.map(&:weight).sum
      nom = test_groups.reduce(0) { |sum, tg| sum + (tg.accepted? ? tg.weight : 0) }
      self.grade = (Float(nom)/denom)*100.0
      update_problem_solution
    else
      self.grade = 0
    end

    save!
  end
  handle_asynchronously :calculate_grade

end
