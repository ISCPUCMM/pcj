class ProblemsController < ApplicationController
  before_action :logged_in_user
  before_action :check_problem_ownership, only: [:show, :edit, :update, :destroy, :upload_input_files]


  def index
    @problems = Problem.owned_by(current_user)
  end

  # def show
  #   @problem = Problem.find(params[:id])
  # end

  def new
    @problem = Problem.new
  end

  def edit
    @problem = Problem.find(params[:id])
  end

  def upload_input_files
    @problem = Problem.find(params[:id])
    flash[:success] = 'Input files uploaded successfully' if @problem.upload_input_files(upload_input_files_params)
    redirect_to :back
  end
  # def destroy
  #   Course.find(params[:id]).destroy
  #   flash[:success] = 'Course deleted'
  #   redirect_to administration_user_path(current_user)
  # end

  # def remove_student
  #   @course = Course.find(params[:id])
  #   student_id = params[:student_id]

  #   if @course.remove_student(student_id)
  #     flash[:success] = 'Student removed successfully'
  #   else
  #     flash[:warning] = 'Something funky happened :)'
  #   end

  #   redirect_to edit_course_path(params[:id])
  # end

  def create
    @problem = Problem.new(problem_params.merge(owner: current_user))
    if @problem.save
      flash[:info] = 'Problem created successfully'
      redirect_to edit_problem_path(@problem)
    else
      render 'new'
    end
  end

  def update
    @problem = Problem.find(params[:id])
    if @problem.update_attributes(problem_params)
      flash[:success] = 'Problem updated'
      redirect_to administration_user_path(current_user)
    else
      render 'edit'
    end
  end

  private  def problem_params
    params.require(:problem).permit(:name, :statement, :input_format, :output_format, :examples, :notes)
  end

  private  def upload_input_files_params
    params.require(:problem).permit(:input_files)
  end
  # private def student_params
  #   params.require(:course).permit(:student)
  # end
  private def check_problem_ownership
    if current_user?(Problem.find(params[:id]).owner)
      true
    else
      flash[:danger] = "You do not have access to view page"
      redirect_to(root_url)
    end
  end
end
