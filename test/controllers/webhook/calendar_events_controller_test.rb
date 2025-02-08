require "test_helper"

class Webhook::CalendarEventsControllerTest < ActionDispatch::IntegrationTest
  test "webhookを受けてjobに流す" do
    assert_enqueued_jobs 1, only: SyncGoogleCalendarEventsJob do
      post "/webhook/calendar_events", headers: { "X-Goog-Channel-ID" => "calendar_2", "X-Goog-Channel-Token" => "dummy2" }
    end

    assert_response :ok
  end

  test "トークンがおかしい場合は無視" do
    assert_no_enqueued_jobs do
      post "/webhook/calendar_events", headers: { "X-Goog-Channel-ID" => "calendar_2", "X-Goog-Channel-Token" => "invalid" }
    end

    assert_response :bad_request
  end

  test "カレンダーが見つからないとき" do
    post "/webhook/calendar_events", headers: { "X-Goog-Channel-ID" => "dummy" }

    assert_response :not_found
  end
end
