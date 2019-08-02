class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to entry_path(id: params[:entry_id])
      # respond_to do |format|
      # format.html { redirect_to entry_path(id: params[:entry_id]) }
      # format.js
      #end
    else
      flash[:danger] = "Comment!"
      redirect_to root_path
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to entry_path(id: @comment.entry_id)
    # respond_to do |format|
    #   format.html { redirect_to entry_path(id: params[:entry_id]) }
    #   format.js
    # end
  end

  private

    def comment_params
      params.require(:comment).permit(:content).merge({entry_id: params[:entry_id]})
    end

    def correct_user
      @comment = current_user.comments.find_by id: params[:id]
      redirect_to entry_path(id: params[:entry_id]) if @comment.nil?
    end
end
