module StudentPortal
  class CoursesController < ApplicationController
    before_action :logged_in_user
    before_action :correct_user

    def index
      @courses = User.find(params[:user_id]).courses
    end

    private def correct_user
      @user = User.find(params[:user_id])
      if current_user?(@user)
        true
      else
        flash[:danger] = "You do not have access to view page"
        redirect_to(root_url)
      end
    end
  end
end
