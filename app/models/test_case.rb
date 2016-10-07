class TestCase < ActiveRecord::Base
  scope :ungrouped, -> { where(test_group: nil) }
  scope :grouped, -> { where('test_group_id is NOT NULL') }

  belongs_to :test_group

  attr_accessor :selected

  belongs_to :problem
  validates_presence_of :problem

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
