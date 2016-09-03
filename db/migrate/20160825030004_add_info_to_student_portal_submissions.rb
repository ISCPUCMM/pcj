class AddInfoToStudentPortalSubmissions < ActiveRecord::Migration
  def change
    add_column :student_portal_submissions, :info, :string
  end
end
