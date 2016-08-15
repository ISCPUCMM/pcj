module StudentPortal
  class ProblemSolutionsController < ApplicationController
    before_action :load_problem_solution
    before_action :correct_user

    def test
      task = Runner.new(test_solution_params.slice(:code, :input, :language).merge(time_limit: @problem_solution.time_limit))
      if task.valid?
        render json: task.commit, status: :ok
      else
        render json: { errors: task.errors.full_messages.join('; ') }, status: :unprocessable_entity
      end
    end

    def submit
      byebug
    end

    def save_code
      if @problem_solution.update_attributes(code: params[:code])
        render json: {}, status: :ok
      else
        render json: { errors: @problem_solution.errors.full_messages.join('; ') }, status: :unprocessable_entity
      end
    end

    private def submit_solution_params
      params.require(:student_portal_problem_solution).permit(:id, :code, :language)
    end

    private  def test_solution_params
      params.require(:student_portal_problem_solution).permit(:id, :input, :code, :language)
    end

    private def load_problem_solution
      @problem_solution = StudentPortal::ProblemSolution.find_by_id(params[:id]) or not_found
    end

    private def correct_user
      if current_user?(@problem_solution.user)
        true
      else
        flash[:danger] = 'You do not have access to view page'
        redirect_to(root_url) and return false
      end
    end
  end
end
