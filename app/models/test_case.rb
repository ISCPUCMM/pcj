class TestCase < ActiveRecord::Base
  belongs_to :problem
  validates_presence_of :problem

  def s3_input_key
    "#{problem_id}/#{tc_index}.in"
  end

  def s3_output_key
    "#{problem_id}/#{tc_index}.out"
  end
end
