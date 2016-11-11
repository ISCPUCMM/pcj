module StudentPortal
  class ProblemSolutionsController < ApplicationController
    before_action :load_problem_solution, except: :user_solutions
    before_action :correct_user?, except: :user_solutions
    before_action :course_owner?, only: :user_solutions

    def test
      code = test_solution_params[:code]
      input = test_solution_params[:input]
      language = test_solution_params[:language]

      runner = @problem_solution.runner(submitted_code: code, submitted_language: language, submitted_input: input)
      if runner.valid?
        render json: runner.commit, status: :ok
      else
        render json: { errors: runner.errors.full_messages.join('; ') }, status: :unprocessable_entity
      end
    end

    def submit
      if @problem_solution.submit(submitted_code: submit_solution_params[:code], submitted_language: submit_solution_params[:language])
        flash[:info] = 'Solution submitted'
        redirect_to submissions_path_for(@problem_solution)
      else
        flash[:danger] = 'Code and Language can\'t be blank'
        redirect_to problem_show_path_for(@problem_solution)
      end
    end

    def save_code
      if @problem_solution.update_attributes({code: params[:code], language: params[:language]})
        render json: {}, status: :ok
      else
        render json: { errors: @problem_solution.errors.full_messages.join('; ') }, status: :unprocessable_entity
      end
    end

    def user_solutions
      render json: StudentPortal::ProblemSolution.where(user_solutions_params).select(:problem_id, :code, :language), status: :ok
    end

    private def submit_solution_params
      params.require(:student_portal_problem_solution).permit(:id, :code, :language)
    end

    private  def test_solution_params
      params.require(:student_portal_problem_solution).permit(:id, :input, :code, :language)
    end

    private def user_solutions_params
      params.require(:student_portal_problem_solutions).permit(:course_id, :assignment_id, :user_id)
    end

    private def load_problem_solution
      @problem_solution = StudentPortal::ProblemSolution.find_by_id(params[:id]) or not_found
    end

    private def correct_user?
      if current_user?(@problem_solution.user)
        true
      else
        flash[:danger] = 'You do not have access to view page'
        redirect_to(root_url) and return false
      end
    end

    private def course_owner?
      course = Course.find_by_id(user_solutions_params[:course_id]) or not_found

      if course.owner.eql?(current_user)
        true
      else
        unauthorized_access_message_and_redirect_to root_url
      end
    end

    private def problem_show_path_for(problem_solution)
      user_student_portal_course_assignment_problem_path(problem_solution.problem_mapping_attributes)
    end

    private def submissions_path_for(problem_solution)
      user_student_portal_course_assignment_submissions_path(problem_solution.problem_mapping_attributes.except(:id))
    end
  end
end
