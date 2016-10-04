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

  def unadded_assignments
    owner.assignment_ownerships.where.not(id: assignments.pluck(:id))
  end

  def remove_student(student_id)
    student_relation = CourseStudent.find_by_course_id_and_user_id(self, student_id)
    student_relation.present? ? student_relation.destroy : false
  end

  def add_students(student_ids)
    student_ids.reject!(&:blank?)

    return false if student_ids.empty?

    student_objects = student_ids.map { |sid| students.find_by_id(sid) }

    if student_objects.all?(&:nil?)
      owner.connections.where(id: student_ids).find_each do |student|
        students << student
      end

      true
    else
      false
    end
  end

  def add_student(student_id)
    if (student_id.blank? || students.find_by_id(student_id))
      false
    else
      students << owner.find_by_id(student_id)
      true
    end
  end

  def remove_assignment(assignment_id)
    assignment_relation = CourseAssignment.find_by_course_id_and_assignment_id(self, assignment_id)
    assignment_relation.present? ? assignment_relation.destroy : false
  end

  def add_assignment(assignment_id)
    if (assignment_id.blank? || assignments.find_by_id(assignment_id))
      false
    else
      assignments << Assignment.find_by_id(assignment_id)
      true
    end
  end
end
