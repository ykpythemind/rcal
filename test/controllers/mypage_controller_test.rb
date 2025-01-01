require "test_helper"

class MypageControllerTest < ActionDispatch::IntegrationTest
  test "access" do
    login_as(users(:one))
    get "/mypage"
    assert_response :ok
  end
end
