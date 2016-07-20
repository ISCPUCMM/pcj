class AddCodeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :code, :text
  end
end
