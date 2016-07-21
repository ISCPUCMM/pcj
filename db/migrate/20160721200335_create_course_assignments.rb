class CreateCourseAssignments < ActiveRecord::Migration
  def change
    create_table :course_assignments do |t|
      t.integer :course_id
      t.integer :assignment_id

      t.timestamps null: false
    end

    add_index :course_assignments, :course_id
    add_index :course_assignments, :assignment_id
    add_index :course_assignments, [:course_id, :assignment_id], unique: true
  end
end

