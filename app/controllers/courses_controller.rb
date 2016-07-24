class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :check_course_ownership, only: [:show, :edit, :update, :destroy, :add_student, :remove_student]

  def index
    @courses = Course.owned_by(current_user)
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.find(params[:id])
  end

  def destroy
    Course.find(params[:id]).destroy
    flash[:success] = 'Course deleted'
    redirect_to administration_user_path(current_user)
  end

  def add_student
    @course = Course.find(params[:id])
    student_id = student_params[:student]

    if @course.add_student(student_id)
      flash[:success] = 'Student added successfully to course'
    else
      flash[:warning] = 'Invalid selection'
    end
    redirect_to edit_course_path(params[:id])
  end

  def remove_student
    @course = Course.find(params[:id])
    student_id = params[:student_id]

    if @course.remove_student(student_id)
      flash[:success] = 'Student removed successfully from course'
    else
      flash[:warning] = 'Something funky happened :)'
    end

    redirect_to edit_course_path(params[:id])
  end

  def add_assignment
    @course = Course.find(params[:id])
    assignment_id = assignment_params[:assignment]

    if @course.add_assignment(assignment_id)
      flash[:success] = 'Assignment added successfully to course'
    else
      flash[:warning] = 'Invalid selection'
    end
    redirect_to edit_course_path(params[:id])
  end

  def remove_assignment
    @course = Course.find(params[:id])
    assignment_id = params[:assignment_id]

    if @course.remove_assignment(assignment_id)
      flash[:success] = 'Assignment removed successfully from course'
    else
      flash[:warning] = 'Something funky happened :)'
    end

    redirect_to edit_course_path(params[:id])
  end

  def create
    @course = Course.new(course_params.merge(owner: current_user))
    if @course.save
      flash[:info] = 'Course created successfully. Add students below or press cancel to go back to the menu.'
      redirect_to edit_course_path(@course)
    else
      render 'new'
    end
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params)
      flash[:success] = 'Course updated'
      redirect_to administration_user_path(current_user)
    else
      render 'edit'
    end
  end

  private  def course_params
    params.require(:course).permit(:name)
  end

  private def student_params
    params.require(:course).permit(:student)
  end

  private def assignment_params
    params.require(:course).permit(:assignment)
  end

  private def check_course_ownership
    if current_user?(Course.find(params[:id]).owner)
      true
    else
      flash[:danger] = "You do not have access to view page"
      redirect_to(root_url)
    end
  end
end
