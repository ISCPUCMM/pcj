module StudentPortal
  class CoursesController < StudentPortal::BaseController
    def index
      @courses = @user.courses
    end
  end
end
