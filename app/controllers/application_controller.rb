class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user

  def current_user
    # Assuming you have a User model and session-based authentication
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
