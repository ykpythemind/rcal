class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  around_action :with_locale

  def with_locale
    # TODO: should guess locale from request
    I18n.with_locale(I18n.default_locale) do
      yield
    end
  end

  def current_user
    @current_user ||= User.find_by(uid: session[:uid])
  end

  helper_method :current_user

  rescue_from Google::Apis::ClientError do |e|
    if JSON.parse(e.body).dig("error", "status") == "PERMISSION_DENIED"
      redirect_to root_path, alert: "Googleカレンダーに対して必要な権限がありません。ログアウトしてやり直してください"
    else
      raise e
    end
  end

  def require_login
    unless current_user
      redirect_to root_path, alert: "You must be logged in"
    end
  end
end
