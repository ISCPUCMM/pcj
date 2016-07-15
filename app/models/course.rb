class Course < ActiveRecord::Base
  has_many :course_students
  has_many :users, through: :course_students
  belongs_to :owner, class_name: :User
  validates_presence_of :name, :owner
  alias students users

end
