module StudentPortal
  class AssignmentsController < StudentPortal::BaseController
    before_action :load_course
    before_action :correct_course

    def index
      @assignments = @course.assignments
    end
  end
end
