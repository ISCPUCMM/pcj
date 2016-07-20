class AddOutputsGenerationInfoToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :outputs_generation_info, :text
  end
end
