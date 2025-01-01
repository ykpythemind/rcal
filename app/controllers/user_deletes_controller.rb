class UserDeletesController < ApplicationController
  before_action :require_login

  def show
  end

  def create
    current_user.destroy!
    reset_session

    flash[:notice] = "退会しました"
    redirect_to root_path
  end
end
