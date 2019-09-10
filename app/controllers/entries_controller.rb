class EntriesController < ApplicationController
  before_action :logged_in_user, only: %i{create, destroy}
  before_action :correct_user, only: %i{destroy}

  def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save
      flash[:success] = "Created!"
      redirect_to root_path
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    @entry.destroy
    flash[:success] = "Micropost deleted"
    redirect_to  root_path
  end

  def show
    #byebug
    @entry = Entry.find_by id: params[:id]
    @comments = @entry.comments.paginate(page: params[:page], per_page: 5)
  end

  private
    def entry_params
      params.require("entry").permit(:title, :body, :picture)
    end

    def correct_user
      @entry = current_user.entries.find_by id: params[:id]
      redirect_to root_path if @entry.nil?
    end
end
