class CommentsController < ApplicationController
    before_action :require_login

    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.build(comment_params)
        @comment.user = current_user

        if @comment.save
        redirect_to post_path(@post), notice: "Comment added successfully."
        else
        @comments = @post.comments.includes(:user).order(created_at: :desc)
        flash[:alert] = "Error adding comment."
        render "posts/show", status: :unprocessable_entity
        end
    end

    private
    def require_login
        redirect_to login_path unless current_user
    end

    def comment_params
        params.require(:comment).permit(:content)
    end
end
