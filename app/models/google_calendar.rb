class GoogleCalendar < ApplicationRecord
  after_destroy_commit :cleanup_watching_channel

  has_many :google_calendar_events, dependent: :destroy

  belongs_to :user

  def start_watch(access_token)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = access_token

    self.channel_id = SecureRandom.uuid
    channel_param = Google::Apis::CalendarV3::Channel.new(
      id: self.channel_id, type: "web_hook", address: webhook_calendar_events_url
    )

    service.watch_event(calendar_id, channel_param, show_deleted: true)

    save!
  end

  def webhook_calendar_events_url
    "https://#{Rails.application.config.x.host}/webhook/calendar_events"
  end

  private

  def cleanup_watching_channel
    # its not working
    # <Google::Apis::ClientError: notFound: Channel 'c7fe2f16-0d4d-4b45-9479-d2184ca82ecb' not found for project '372583231215' status_code: 404 header
    return unless ENV["CLEANUP"]

    token = user.google_access_token&.prepare
    return unless token

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = token

    chan = Google::Apis::CalendarV3::Channel.new(id: channel_id, resource_id: calendar_id)

    begin
      service.stop_channel(chan)
    rescue => e
      Rails.logger.error(e)

      raise if Rails.env.local?
    end
  end
end
