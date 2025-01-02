class NotificationsController < ApplicationController
  before_action :require_login
  before_action :set_notification, only: [ :destroy ]

  def destroy
    @notification.mark_as_read!
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
end
