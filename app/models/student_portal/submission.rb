class StudentPortal::Submission < ActiveRecord::Base
  belongs_to :problem_solution, class_name: 'StudentPortal::ProblemSolution'


  enum status: { pending: 0, accepted: 1, wa: 2, error: 3 }

end
