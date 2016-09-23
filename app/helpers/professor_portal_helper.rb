module ProfessorPortalHelper
  def student_work_so_far_dropdown_for(course)
    course.users.pluck(:name, :id)
  end
end
