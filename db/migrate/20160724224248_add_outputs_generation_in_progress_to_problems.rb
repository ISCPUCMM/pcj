class AddOutputsGenerationInProgressToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :outputs_generation_in_progress, :bool
  end
end
