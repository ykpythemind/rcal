class GoogleCallbacksController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]

    user = User.create_or_find_by!(uid: auth_hash.uid)

    User.transaction do
      user.update!(nickname: auth_hash.info[:name])
      user.google_access_token&.destroy!
      user.create_google_access_token!(
        access_token: auth_hash.credentials.token,
        refresh_token: auth_hash.credentials.refresh_token,
        expires_at: Time.at(auth_hash.credentials.expires_at)
      )
    end

    reset_session
    session[:uid] = user.uid

    redirect_to root_path
  end
end
