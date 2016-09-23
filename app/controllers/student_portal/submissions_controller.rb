module StudentPortal
  class SubmissionsController < ApplicationController
    before_action :logged_in_user
    before_action :load_submission
    before_action :can_view_submission

    def show
      redirect_to @submission.submission_url
    end

    private def load_submission
      @submission = StudentPortal::Submission.find_by_id(params[:id]) or not_found
    end

    private def can_view_submission
      if @submission.user.eql?(current_user) || @submission.course.owner.eql?(current_user)
        true
      else
        unauthorized_access_message_and_redirect_to root_url
      end
    end
  end
end
