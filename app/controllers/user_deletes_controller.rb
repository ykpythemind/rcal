class UserDeletesController < ApplicationController
  before_action :require_login

  def show
  end

  def create
    current_user.destroy!
    reset_session

    flash[:notice] = "アカウントを削除しました"
    redirect_to root_path
  end
end
