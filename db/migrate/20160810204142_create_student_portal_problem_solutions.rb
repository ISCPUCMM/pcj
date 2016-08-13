class CreateStudentPortalProblemSolutions < ActiveRecord::Migration
  def change
    create_table :student_portal_problem_solutions do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :assignment_id
      t.integer :problem_id
      t.text :code

      t.timestamps null: false
    end

    add_index :student_portal_problem_solutions, :user_id
    add_index :student_portal_problem_solutions, :course_id
    add_index :student_portal_problem_solutions, :assignment_id
    add_index :student_portal_problem_solutions, :problem_id
    add_index :student_portal_problem_solutions, [:course_id, :assignment_id, :problem_id, :user_id], unique: true, name: 'problem_solution_index'
  end
end
