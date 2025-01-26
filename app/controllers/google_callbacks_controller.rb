class GoogleCallbacksController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]

    scope = auth_hash.credentials.scope
    unless scope.include?("https://www.googleapis.com/auth/calendar")
      flash[:error] = "カレンダーの権限の許可が必要です"

      return redirect_to root_path
    end

    user = User.create_or_find_by!(uid: auth_hash.uid)

    User.transaction do
      user.update!(nickname: auth_hash.info[:name], email: auth_hash.info[:email])
      user.google_access_token&.destroy!

      user.create_google_access_token!(
        access_token: auth_hash.credentials.token,
        refresh_token: auth_hash.credentials.refresh_token,
        expires_at: Time.at(auth_hash.credentials.expires_at)
      )
    end

    reset_session
    session[:uid] = user.uid
    flash[:notice] = "ログインしました"

    redirect_to root_path
  end
end
