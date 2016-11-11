class AddLanguageToStudentPortalProblemSolutions < ActiveRecord::Migration
  def change
    add_column :student_portal_problem_solutions, :language, :string
  end
end
