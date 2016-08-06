module StudentPortal
  class AssignmentsController < ApplicationController
    before_action :load_user
    before_action :load_course
    before_action :logged_in_user
    before_action :correct_user
    before_action :correct_course

    def index
      @assignments = @course.assignments
    end

    private def load_user
      @user = User.find_by_id(params[:user_id]) or not_found
    end

    private def load_course
      @course = Course.find_by_id(params[:course_id]) or not_found
    end

    private def correct_user
      if current_user?(@user)
        true
      else
        flash[:danger] = 'You do not have access to view page'
        redirect_to(root_url)
      end
    end

    private def correct_course
      if @course.students.where(id: @user).present?
        true
      else
        flash[:danger] = 'You do not have access to view page'
        redirect_to(user_student_portal_courses_path(@user))
      end
    end
  end
end
