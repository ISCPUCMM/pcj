class AddProblemToTestGroups < ActiveRecord::Migration
  def change
    add_column :test_groups, :problem_id, :integer
  end
end
