class AddStatusAndGradeToStudentPortalProblemSolutions < ActiveRecord::Migration
  def change
    add_column :student_portal_problem_solutions, :grade, :float, default: 0
    add_column :student_portal_problem_solutions, :status, :integer, default: 0
  end
end
