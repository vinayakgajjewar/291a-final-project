class PostsController < ApplicationController
    before_action :require_login
    before_action :authorize_user, only: [ :edit, :update, :destroy ]

    def index
        @posts = Post.includes(:user).order(created_at: :desc)
    end

    def new
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)

        if @post.save
            redirect_to root_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show
        @post = Post.find(params[:id])
        @comments = @post.comments.includes(:user).order(created_at: :desc)
    rescue ActiveRecord::RecordNotFound
        render file: "#{Rails.root}/public/404.html", status: :not_found
    end

    def edit
        @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render file: "#{Rails.root}/public/404.html", status: :not_found
    end

    def update
        if @post.update(post_params)
            redirect_to post_path(@post)
        else
            render :edit, alert: "Error updating the post."
        end
    end

    def destroy
        @post = Post.find(params[:id])
        if @post.destroy
            redirect_to root_path
        else
            redirect_to root_path, alert: "Error deleting the post."
        end
    rescue ActiveRecord::RecordNotFound
        render file: "#{Rails.root}/public/404.html", status: :not_found
    end

    # private

    def post_params
        params.require(:post).permit(:content)
    end

    def require_login
        redirect_to login_path unless current_user
    end

    def authorize_user
        @post = Post.find(params[:id])
        redirect_to root_path, alert: "Not authorized" unless @post.user == current_user
    rescue ActiveRecord::RecordNotFound
            render file: "#{Rails.root}/public/404.html", status: :not_found
    end
end
