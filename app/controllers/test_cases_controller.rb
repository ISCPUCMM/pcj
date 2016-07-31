class TestCasesController < ApplicationController
  before_action :logged_in_user
  before_action :check_problem_ownership

  def show_input_file
    @test_case = TestCase.find(params[:id])
    redirect_to @test_case.input_file_url
  end

  def show_output_file
    @test_case = TestCase.find(params[:id])
    redirect_to @test_case.output_file_url
  end

  private def check_problem_ownership
    if current_user?(TestCase.find(params[:id]).problem.owner)
      true
    else
      flash[:danger] = "You do not have access to view page"
      redirect_to(root_url)
    end
  end
end
