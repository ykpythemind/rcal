class NotificationsController < ApplicationController
  before_action :require_login
  before_action :set_notification, only: [ :destroy ]

  def destroy
    @notification.mark_as_read!

    # TODO: turbo frame
    redirect_to root_path
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
end
