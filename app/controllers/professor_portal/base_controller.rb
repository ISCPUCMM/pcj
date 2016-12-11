module ProfessorPortal
  class BaseController < ApplicationController
    before_action :logged_in_user

    before_action :load_user
    before_action :correct_user

    private def load_user
      @user = User.find_by_id(params[:user_id]) or not_found
    end

    private def correct_user
      if current_user?(@user) && current_user.professor?
        true
      else
        flash[:danger] = 'You do not have access to view page'
        redirect_to(root_url) and return false
      end
    end

    private def load_course
      @course = Course.find_by_id(params[:course_id]) or not_found
    end

    private def correct_course
      if @course.owner.eql?(@user)
        true
      else
        unauthorized_access_message_and_redirect_to user_professor_portal_courses_path(@user)
      end
    end

    private def load_assignment
      @assignment = @course.assignments.find_by(id: params[:assignment_id]) or not_found
    end

    private def correct_assignment
      if @assignment
        true
      else
        unauthorized_access_message_and_redirect_to user_professor_portal_courses_path(@user)
      end
    end
  end
end
