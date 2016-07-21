class CreateAssignmentProblem < ActiveRecord::Migration
  def change
    create_table :assignment_problems do |t|
      t.integer :assignment_id
      t.integer :problem_id

      t.timestamps null: false
    end

    add_index :assignment_problems, :assignment_id
    add_index :assignment_problems, :problem_id
    add_index :assignment_problems, [:assignment_id, :problem_id], unique: true
  end
end
