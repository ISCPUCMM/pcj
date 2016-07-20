class AddOutputsGeneratedAtToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :outputs_generated_at, :datetime
  end
end
