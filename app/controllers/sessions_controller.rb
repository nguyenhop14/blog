class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:session].present?
      user = User.find_by email: params[:session][:email].downcase
      if user && user.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:danger].now = "invalid email/password combination"
        render :new
      end
    else
      begin
        user = User.from_omniauth[request.env["omniauth.auth"]]
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.email}!"
      rescue
        flash[:wraning] = "There was an error while trying  to authenticate you ..."
      end
      # flash[:wraning] = "There was an error while trying  to authenticate you ..."
      redirect_to root_path
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def failure
    render :text => "Sorry, but you didn't allow access to our app"
  end
end
