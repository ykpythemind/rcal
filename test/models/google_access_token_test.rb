require "test_helper"

class GoogleAccessTokenTest < ActiveSupport::TestCase
  test "when token is wrong" do
    WebMock.allow_net_connect!
    with_env({ FORCE_REFRESH_TOKEN: "true" }) do
      token = users(:one).google_access_token
      token.update!(expires_at: 1.day.ago)

      assert_not(users(:one).notifications.exists?(notification_type: :authorize_needed))

      # 有効なトークンがないので必ず失敗する
      assert_raises(Signet::AuthorizationError) do
        token.prepare
      end

      assert { users(:one).notifications.where(notification_type: :authorize_needed).count == 1 }

      # 有効なトークンがないので必ず失敗する
      assert_raises(Signet::AuthorizationError) do
        token.prepare
      end

      assert { users(:one).notifications.where(notification_type: :authorize_needed).count == 1 }
    end
  end
end
