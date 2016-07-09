class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    if User.find(params[:id]).destroy
      flash[:success] = 'Successfully deleted user'
      redirect_to :back
    else
      flash[:warning] = 'Unable to delete user'
      redirect_to :back
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Welcome to the Programming Class Judge!'
      redirect_to @user
    else
      render 'new'
    end
  end


  private  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
