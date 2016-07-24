class CourseAssignment < ActiveRecord::Base
  belongs_to :course
  belongs_to :assignment
end
