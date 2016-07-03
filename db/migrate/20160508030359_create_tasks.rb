class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :time_limit
      t.string :language
      t.string :file_key
      t.integer :submission_id
      t.integer :problem_id
      t.string :type

      t.timestamps null: false
    end
  end
end
