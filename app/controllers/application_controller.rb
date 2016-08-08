class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def index
  end

  private def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  private def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private def unauthorized_access_message_and_redirect_to(redirect)
    flash[:danger] = 'You do not have access to view page'
    redirect_to((redirect || root_url)) and return false
  end
end
