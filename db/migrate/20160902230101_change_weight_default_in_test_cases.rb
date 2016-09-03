class ChangeWeightDefaultInTestCases < ActiveRecord::Migration
  def change
    change_column_default :test_cases, :weight, 10
  end
end
