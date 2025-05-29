require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Test", email: "test@example.com", password: "password")
    @token = JsonWebToken.encode(user_id: @user.id)

    @post = Post.create!(title: "Sample Post", body: "Body text", tags: ["tag1"], user: @user)
  end

  test "should get index" do
    get "/posts", headers: auth_headers
    assert_response :success
  end

  test "should create post" do
    assert_difference("Post.count") do
      post "/posts", params: {
        post: {
          title: "New Post",
          body: "Some content",
          tags: ["ruby", "rails"]
        }
      }, headers: auth_headers
    end

    assert_response :created
  end

  test "should update own post" do
    patch "/posts/#{@post.id}", params: {
      post: { title: "Updated" }
    }, headers: auth_headers

    assert_response :success
    assert_equal "Updated", @post.reload.title
  end

  test "should not update another user's post" do
    other_user = User.create!(name: "Other", email: "other@example.com", password: "password")
    other_post = Post.create!(title: "Other", body: "text", tags: ["x"], user: other_user)

    patch "/posts/#{other_post.id}", params: {
      post: { title: "Hacked" }
    }, headers: auth_headers

    assert_response :forbidden
  end

  private

  def auth_headers
    { "Authorization" => "Bearer #{@token}" }
  end
end
