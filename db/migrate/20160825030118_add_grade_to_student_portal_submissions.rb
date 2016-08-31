class AddGradeToStudentPortalSubmissions < ActiveRecord::Migration
  def change
    add_column :student_portal_submissions, :grade, :float
  end
end
