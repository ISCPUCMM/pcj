class CreateCourseStudent < ActiveRecord::Migration
  def change
    create_table :course_students do |t|
      t.string :user_id
      t.string :course_id

      t.timestamps null: false
    end
  end
end
