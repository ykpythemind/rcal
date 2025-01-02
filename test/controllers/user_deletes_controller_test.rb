require "test_helper"

class UserDeletesControllerTest < ActionDispatch::IntegrationTest
  test "#show" do
    login_as(users(:one))

    get "/users/delete"
    assert_response :success
  end

  test "アカウント削除できる" do
    login_as(users(:one))

    WebMock.disable_net_connect!

    stub_request(:post, "https://www.googleapis.com/calendar/v3/channels/stop").and_return(status: 200, body: "", headers: { "Content-Type": "application/json" })

    post "/users/delete"
    assert_response :redirect

    assert { User.find_by(id: users(:one).id) == nil }
  end
end
