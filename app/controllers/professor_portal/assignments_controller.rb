module ProfessorPortal
  class AssignmentsController < ProfessorPortal::BaseController
    before_action :load_user
    before_action :correct_user

    before_action :load_course
    before_action :correct_course

    before_action :load_assignment, except: :index
    before_action :correct_assignment, except: :index

    def index
      @assignments = @course.assignments
    end

    def student_solutions
      @submissions = StudentPortal::Submission.course_assignment_submissions_for(@course, @assignment)
                       .most_recent.paginate(page: params[:page], per_page: 10)
    end

    def student_statistics
      @student_solutions = StudentPortal::ProblemSolution.course_assignment_solutions_for(@course, @assignment)
    end
  end
end
