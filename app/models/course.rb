class Course < ActiveRecord::Base
  has_many :course_assignments
  has_many :assignments, through: :course_assignments
  has_many :course_students
  has_many :users, through: :course_students
  belongs_to :owner, class_name: :User
  validates_presence_of :name, :owner
  alias students users

  scope :owned_by, -> (user) { where(owner: user) }

  def unadded_students
    owner.connections.where.not(id: students.pluck(:id))
  end

  def remove_student(student_id)
    student_relation = CourseStudent.find_by_course_id_and_user_id(self, student_id)
    student_relation.present? ? student_relation.destroy : false
  end

  def add_student(student_id)
    if (student_id.blank? || students.find_by_id(student_id))
      false
    else
      students << User.find_by_id(student_id)
      save!
      true
    end
  end
end
