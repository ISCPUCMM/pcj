class ProblemsController < ApplicationController
  before_action :logged_in_user

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

  # def update
  #   @course = Course.find(params[:id])
  #   if @course.update_attributes(course_params)
  #     flash[:success] = 'Course updated'
  #     redirect_to administration_user_path(current_user)
  #   else
  #     render 'edit'
  #   end
  # end

  private  def problem_params
    params.require(:problem).permit(:name, :statement, :input_format, :output_format, :examples, :notes)
  end

  # private def student_params
  #   params.require(:course).permit(:student)
  # end

end
