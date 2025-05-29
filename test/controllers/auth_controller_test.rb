require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "should signup a user" do
    post "/signup", params: {
      name: "Test User",
      email: "test@example.com",
      password: "password123"
    }

    assert_response :created
    json = JSON.parse(response.body)
    assert json["token"].present?, "Token should be present in response"
  end

  test "should login a user" do
    # First, create the user
    User.create!(
      name: "Test User",
      email: "test@example.com",
      password: "password123"
    )

    post "/login", params: {
      email: "test@example.com",
      password: "password123"
    }

    assert_response :success
    json = JSON.parse(response.body)
    assert json["token"].present?, "Token should be present in response"
  end
end
