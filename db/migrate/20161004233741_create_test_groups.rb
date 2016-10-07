class CreateTestGroups < ActiveRecord::Migration
  def change
    create_table :test_groups do |t|
      t.integer :weight, default: 10
    end
  end
end
