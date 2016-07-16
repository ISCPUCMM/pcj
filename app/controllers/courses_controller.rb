class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :check_course_ownership, only: [:show, :edit, :update, :drestroy]

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
    redirect_to user_administration_path(current_user)
  end

  def create
    @course = Course.new(course_params.merge(owner: current_user))
    if @course.save
      flash[:info] = 'Course created successfully'
      redirect_to user_administration_path(current_user)
    else
      render 'new'
    end
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params)
      flash[:success] = 'Course updated'
      redirect_to user_administration_path(current_user)
    else
      render 'edit'
    end
  end

  private  def course_params
    params.require(:course).permit(:name)
  end

  private def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
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
