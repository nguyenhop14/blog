class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :get_entry, :get_comments, only: %i{create}
  # after_action :get_comments, only: %i{destroy}
  def create
    @comment = current_user.comments.build comment_params
    if @comment.save
      respond_to do |format|
        format.html { redirect_to entry_path(id: params[:entry_id]) }
        format.js
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted"
    respond_to do |format|
      format.html { redirect_to entry_path id: @comment.entry_id }
      format.js
    end
  end

  private
    def comment_params
      (params.require(:comment).permit(:content)).merge({entry_id: params[:entry_id]})
    end

    def correct_user
      @comment = current_user.comments.find_by id: params[:id]
      redirect_to entry_path(id: params[:entry_id]) if @comment.nil?
    end

    def get_entry
      @entry = Entry.find_by id: params[:entry_id]
      return if @entry
      flash[:danger] = "test"
      redirect_to root_path
    end

    def get_comments
      @comments = @entry.comments.paginate(page: params[:page], per_page: 5)
    end
end
