class AddInputFilesUploadedAtToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :input_files_uploaded_at, :datetime
  end
end
