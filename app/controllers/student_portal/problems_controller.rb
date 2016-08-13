module StudentPortal
  class ProblemsController < StudentPortal::BaseController
    before_action :load_course_and_assignment
    before_action :correct_course
    before_action :correct_course_assignment
    before_action :assignment_started?, except: [:assignment_start_countdown]

    def index
      @problems = @assignment.problems
    end

    def show
      @problem = @assignment.problems.find(params[:id])
      @problem_solution = StudentPortal::ProblemSolution.find_or_create_by(course: @course,
                                                                           assignment: @assignment,
                                                                           problem: @problem,
                                                                           user: @user)
    end

    def assignment_start_countdown
    end
  end
end
