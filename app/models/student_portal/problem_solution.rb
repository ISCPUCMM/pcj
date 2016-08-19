class StudentPortal::ProblemSolution < ActiveRecord::Base
  belongs_to :course
  belongs_to :assignment
  belongs_to :problem
  belongs_to :user
  has_many :submissions, class_name: 'StudentPortal::Submission'

  attr_accessor :input, :language

  validates_presence_of :course, :assignment, :problem, :user

  def time_limit
    problem.time_limit
  end

  def runner(submitted_language: submitted_language, submitted_code: submitted_code, input: input)
    Runner.new(language: submitted_language, code: submitted_code, input: input, time_limit: time_limit)
  end

  def submit(language: language, submitted_code: submitted_code)
    return false if submitted_code.blank? || language.blank?

    update_attributes(code: submitted_code)
    new_submission = submissions.create!(language: language, code: submitted_code)
  end

  def problem_mapping_attributes
    {
      user_id: user_id,
      course_id: course_id,
      assignment_id: assignment_id,
      id: problem_id
    }
  end
end
