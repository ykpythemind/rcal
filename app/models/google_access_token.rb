class GoogleAccessToken < ApplicationRecord
  belongs_to :user

  def prepare
    if expires_at < Time.current || ENV["FORCE_REFRESH_TOKEN"]
      client_id = Rails.application.config.x.google_client_id
      client_secret = Rails.application.config.x.google_client_secret
      refresher =
        Google::Auth::UserRefreshCredentials.new(refresh_token:, client_id:, client_secret:)

      begin
        refresher.fetch_access_token!
      rescue Signet::AuthorizationError => e
        # 意図せずリフレッシュトークンが無効になったケース
        Rails.logger.error(e)
        user.notifications.where(read: false).find_or_create_by!(notification_type: :authorize_needed) do |notification|
          notification.message = "カレンダーの同期に失敗しています。再度ログイン操作をしてください。"
        end

        raise e
      end

      update!(
        access_token: refresher.access_token,
        refresh_token: refresher.refresh_token,
        expires_at: refresher.expires_in.seconds.from_now
      )
    end

    access_token
  end
end
