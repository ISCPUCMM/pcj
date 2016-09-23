module ProfessorPortalHelper
  def student_work_so_far_dropdown_for(course)
    course.users.order(:name).map { |user| [ user.name_with_email, user.id ] }
  end
end
