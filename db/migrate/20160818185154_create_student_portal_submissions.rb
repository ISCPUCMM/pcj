class CreateStudentPortalSubmissions < ActiveRecord::Migration
  def change
    create_table :student_portal_submissions do |t|
      t.integer :problem_solution_id
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
