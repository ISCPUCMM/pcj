class Assignment < ActiveRecord::Base
  has_many :course_assignments
  has_many :courses, through: :course_assignments
  has_many :assignment_problems
  has_many :problems, through: :assignment_problems
  belongs_to :owner, class_name: :User
  validates_presence_of :name, :owner, :starts_at, :ends_at, :description
  validate :time_span
  scope :owned_by, -> (user) { where(owner: user) }

  #ADD ENDS_AT > STARTED_AT VALIDATION

  def unadded_problems
    owner.problem_ownerships.where.not(id: problems.pluck(:id))
  end

  def remove_problem(problem_id)
    assignment_relation = AssignmentProblem.find_by_assignment_id_and_problem_id(self, problem_id)
    assignment_relation.present? ? assignment_relation.destroy : false
  end

  def add_problem(problem_id)
    if (problem_id.blank? || problems.find_by_id(problem_id))
      false
    else
      problems << Problem.find_by_id(problem_id)
      true
    end
  end


  private def time_span
    if starts_at < DateTime.now
      errors.add(:starts_at, 'must start some time in the future')
    end

    if starts_at >= ends_at
      errors.add(:ends_at, 'must be greater than start time')
    end
  end
end
