module ProfessorPortal
  class CoursesController < ProfessorPortal::BaseController
    def index
      @courses = @user.course_ownerships
    end
  end
end
