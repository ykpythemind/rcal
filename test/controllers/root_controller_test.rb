require "test_helper"

class RootControllerTest < ActionDispatch::IntegrationTest
  test "access" do
    get "/"
    assert_response :ok
  end

  test "with login" do
    login_as(users(:one))

    get "/"
    assert_response :ok

    assert response.body.include?("Welcome, test user!")
  end
end
