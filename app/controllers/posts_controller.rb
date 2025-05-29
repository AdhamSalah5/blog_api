class PostsController < ApplicationController
    before_action :set_post, only: %i[show update destroy]
    before_action :authorize_owner!, only: %i[update destroy]
  
    def index
      posts = Post.includes(:user).all
      render json: posts.as_json(include: { user: { only: [:id, :name, :email] } })
    end
  
    def show
      render json: @post
    end
  
    def create
      post = current_user.posts.build(post_params)
      if post.save
        DeletePostJob.set(wait: 24.hours).perform_later(post.id)
        render json: post, status: :created
      else
        render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      if @post.update(post_params)
        render json: @post
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      @post.destroy
      head :no_content
    end
  
    private
  
    def set_post
      @post = Post.find(params[:id])
    end
  
    def authorize_owner!
      unless @post.user_id == current_user.id
        render json: { error: "You are not authorized to modify this post" }, status: :forbidden
      end
    end
  
    def post_params
      params.require(:post).permit(:title, :body, tags: [])
    end
  end
  