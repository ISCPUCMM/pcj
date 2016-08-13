class StudentPortal::ProblemSolution < ActiveRecord::Base
  belongs_to :course
  belongs_to :assignment
  belongs_to :problem
  belongs_to :user
  attr_accessor :input, :language

  validates_presence_of :course, :assignment, :problem, :user

  def time_limit
    problem.time_limit
  end

end
