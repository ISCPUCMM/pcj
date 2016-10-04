module StudentPortal
  class AssignmentsController < StudentPortal::BaseController
    before_action :load_course, only: :index
    before_action :correct_course, only: :index

    before_action :load_course_and_assignment, except: :index
    before_action :correct_course_assignment, except: :index

    def index
      @assignments = @course.assignments
    end

    def submissions
      @submissions = StudentPortal::Submission
        .course_assignment_user_submissions_for(@course, @assignment, @user)
          .most_recent.paginate(page: params[:page], per_page: 20)
    end
  end
end
