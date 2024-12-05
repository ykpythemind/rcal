class GoogleCalendar < ApplicationRecord
  after_destroy_commit :stop_watching_channel

  has_many :google_calendar_events, dependent: :destroy

  belongs_to :user

  def start_watch(access_token)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = access_token

    self.channel_id = SecureRandom.uuid
    channel_param = Google::Apis::CalendarV3::Channel.new(
      id: self.channel_id, type: "web_hook", address: webhook_calendar_events_url
    )

    ret = service.watch_event(calendar_id, channel_param, show_deleted: true)

    Rails.logger.debug "start_watch"
    Rails.logger.debug ret

    self.channel_resource_id = ret.resource_id
    self.expires_at = Time.zone.at(ret.expiration.to_i / 1000)

    save!

    ActiveRecord.after_all_transactions_commit do
      SyncGoogleCalendarEventsJob.perform_later(self)
      RefreshCalendarWatchJob.set(wait_until: expires_at - 30.minutes).perform_later(self)
    end
  end

  def webhook_calendar_events_url
    "https://#{Rails.application.config.x.host}/webhook/calendar_events"
  end

  def refresh_watch(access_token)
    stop_watching_channel
    update!(channel_id: nil, channel_resource_id: nil, expires_at: nil, next_sync_token: nil)
    start_watch(access_token)
  end

  def stop_watching_channel
    token = user.google_access_token&.prepare
    return unless token

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = token

    chan = Google::Apis::CalendarV3::Channel.new(id: channel_id, resource_id: channel_resource_id)

    begin
      service.stop_channel(chan)
    rescue => e
      Rails.logger.error(e)

      raise if Rails.env.local?
    end
  end
end
