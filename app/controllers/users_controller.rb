class UsersController < ApplicationController
  before_action :logged_in_user, only: %i{edit, update, destroy}
  before_action :correct_user, only: %i{edit, update}
  before_action :admin_user, only: %i{destroy}

  def index
    @users = User.page(params[:page]).per 10
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    @entries = @user.entries.paginate(page: params[:page], per_page: 3)
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Bog"
      redirect_to @user
    else
      render :new
    end
  end

  def self.form_omniauth(auth_hash)
    user = find_or_create_by(id: auth_hash["id"])
    user.name = auth_hash["info"]["name"]
    user.email = auth_hash["info"]["email"]
    user.password = "123456"
    user.password_confirmation = "123456"
    user.save!
    user
  end


  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by id: params[:id]
    if @user.update_attributes user_params
      flash[:success] = "Profile update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User delete"
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
  def user_params
    params.require(:user).permit(:name,:email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
