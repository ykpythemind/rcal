require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "delete notification" do
    user = users(:one)
    notification = user.notifications.create!(
      notification_type: :authorize_needed, message: "カレンダーの同期のために再度ログインが必要です。")

    login_as(user)

    get "/"
    assert_response :ok

    assert { user.notifications.where(read: false).count == 1 }

    delete "/notifications/#{notification.id}"
    assert_response :ok

    assert { user.notifications.where(read: false).count == 0 }
  end
end
