class AddProfessorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :professor, :boolean
  end
end
