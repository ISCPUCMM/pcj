class CreateCourseStudent < ActiveRecord::Migration
  def change
    create_table :course_students do |t|
      t.integer :user_id
      t.integer :course_id

      t.timestamps null: false
    end

    add_index :course_students, :user_id
    add_index :course_students, :course_id
    add_index :course_students, [:user_id, :course_id], unique: true
  end
end
