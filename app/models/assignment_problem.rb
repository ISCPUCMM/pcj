class AssignmentProblem < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :problem
end
