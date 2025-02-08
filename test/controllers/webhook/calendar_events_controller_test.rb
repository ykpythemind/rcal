require "test_helper"

class Webhook::CalendarEventsControllerTest < ActionDispatch::IntegrationTest
  test "webhookを受けてjobに流す" do
    assert_enqueued_jobs 1, only: SyncGoogleCalendarEventsJob do
      post "/webhook/calendar_events", headers: { "X-Goog-Channel-ID" => "calendar_2" }
    end

    assert_response :ok
  end

  test "カレンダーが見つからないとき" do
    post "/webhook/calendar_events", headers: { "X-Goog-Channel-ID" => "dummy" }

    assert_response :not_found
  end
end
