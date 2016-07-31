class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.integer :problem_id
      t.integer :weight
      t.integer :tc_index

      t.timestamps null: false
    end
  end
end
