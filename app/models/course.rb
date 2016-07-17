class Course < ActiveRecord::Base
  has_many :course_students
  has_many :users, through: :course_students
  belongs_to :owner, class_name: :User
  validates_presence_of :name, :owner
  alias students users

  scope :owned_by, -> (user) { where(owner: user) }

  def unadded_students
    owner.connections.where.not(id: students.pluck(:id))
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
