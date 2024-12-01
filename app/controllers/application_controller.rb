class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_user
    @current_user ||= User.find_by(uid: session[:uid])
  end

  helper_method :current_user

  def require_login
    unless current_user
      redirect_to root_path, alert: "You must be logged in"
    end
  end
end
