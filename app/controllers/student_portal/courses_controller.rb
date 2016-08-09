module StudentPortal
  class CoursesController < ApplicationController
    before_action :logged_in_user
    before_action :load_user
    before_action :correct_user

    def index
      @courses = @user.courses
    end

    private def load_user
      @user = User.find_by_id(params[:user_id]) or not_found
    end

    private def correct_user
      if current_user?(@user)
        true
      else
        flash[:danger] = "You do not have access to view page"
        redirect_to(root_url)
      end
    end
  end
end
