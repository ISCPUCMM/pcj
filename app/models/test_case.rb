class TestCase < ActiveRecord::Base
  WEIGHT_MIN = 1
  WEIGHT_MAX = 1000
  WEIGHT_RANGE = (WEIGHT_MIN..WEIGHT_MAX)

  belongs_to :problem
  validates_presence_of :problem
  validates_numericality_of :weight, only_integer: true, greater_than_or_equal_to: WEIGHT_MIN, less_than_or_equal_to: WEIGHT_MAX

  def s3_input_key
    "#{problem_id}/#{tc_index}.in"
  end

  def s3_output_key
    "#{problem_id}/#{tc_index}.out"
  end

  def input_file_url
    Aws::S3::Object.new('pcj-problem-inputs', s3_input_key).presigned_url(:get, expires_in: 2.minutes)
  end

  def output_file_url
    Aws::S3::Object.new('pcj-problem-outputs', s3_output_key).presigned_url(:get, expires_in: 2.minutes)
  end
end
