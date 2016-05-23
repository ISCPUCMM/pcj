class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :time_limit
      t.string :language
      t.string :file_key

      t.timestamps null: false
    end
  end
end
