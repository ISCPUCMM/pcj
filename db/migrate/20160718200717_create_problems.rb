class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :name
      t.text :statement
      t.text :input_format
      t.text :output_format
      t.text :examples
      t.text :notes
      t.integer :owner_id
      t.timestamps null: false
    end
  end
end
