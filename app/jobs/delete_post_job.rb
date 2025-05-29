class DeletePostJob < ApplicationJob
  def perform(post_id)
    post = Post.find_by(id: post_id)
    if post
      post.destroy
      Rails.logger.info "Post #{post_id} was deleted."
    else
      Rails.logger.warn "Post #{post_id} not found."
    end
  end
end
