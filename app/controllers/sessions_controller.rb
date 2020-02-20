class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id 
      route_by_role(user)
    else
      flash[:error] = "Invalid Login"
      render :new
    end
  end

  def destroy
    session.delete(:cart)
    session.delete(:user_id)
    flash[:notice] = "You have logged out!"
    redirect_to '/'
  end

  private

  def route_by_role(user)
    if user.role == 'User'
      redirect_to '/profile'
    elsif user.role == 'MerchantEmployee'
      redirect_to '/merchant'
    else
      redirect_to '/admin'
    end
  end


end