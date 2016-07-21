class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.datetime :starts_at
      t.datetime :ends_at
      t.text :description
      t.integer :owner_id
      t.timestamps null: false
    end
  end
end
