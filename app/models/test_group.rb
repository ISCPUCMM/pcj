class TestGroup < ActiveRecord::Base
  has_many :test_cases
  belongs_to :problem

  WEIGHT_MIN = 1
  WEIGHT_MAX = 1000
  WEIGHT_RANGE = (WEIGHT_MIN..WEIGHT_MAX)
  validates_numericality_of :weight, only_integer: true, greater_than_or_equal_to: WEIGHT_MIN, less_than_or_equal_to: WEIGHT_MAX

end
