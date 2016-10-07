class AddTestGroupToTestCases < ActiveRecord::Migration
  def change
    add_column :test_cases, :test_group_id, :integer
  end
end
