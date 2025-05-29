require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Test", email: "test@example.com", password: "password")
    @token = JsonWebToken.encode(user_id: @user.id)

    @post = Post.create!(title: "Post", body: "Body", tags: ["x"], user: @user)
    @comment = @post.comments.create!(body: "Nice", user: @user)
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post "/posts/#{@post.id}/comments", params: {
        comment: { body: "New comment" }
      }, headers: auth_headers
    end
    assert_response :created
  end

  test "should update own comment" do
    patch "/posts/#{@post.id}/comments/#{@comment.id}", params: {
      comment: { body: "Updated body" }
    }, headers: auth_headers

    assert_response :success
    assert_equal "Updated body", @comment.reload.body
  end

  test "should not update another user's comment" do
    other_user = User.create!(name: "Other", email: "other@example.com", password: "password")
    other_comment = @post.comments.create!(body: "Other comment", user: other_user)

    patch "/posts/#{@post.id}/comments/#{other_comment.id}", params: {
      comment: { body: "Hacked" }
    }, headers: auth_headers

    assert_response :forbidden
  end

  private

  def auth_headers
    { "Authorization" => "Bearer #{@token}" }
  end
end
