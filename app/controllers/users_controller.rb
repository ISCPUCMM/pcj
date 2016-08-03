class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user, except: [:index, :destroy, :new, :create, :connect ]
  before_action :admin_user, only: [:index, :destroy]#USE CANCAN INSTEAD OF FILTERS!!!

  def index
    @users = User.where(activated: true).paginate(page: params[:page], per_page: 30)
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def connect
    connecting_user = User.find_by_connection_token(params[:connection_token])

    if connecting_user.present?
      if connecting_user.connect(current_user)
        flash[:info] = "You are now connected with #{connecting_user.name}"
      else
        flash[:warning] = 'Unable to connect with this user. This user is most likely already a connection.'
      end
    else
      flash[:warning] = 'Invalid Connection Link'
    end

    redirect_to root_url
  end

  def connections
    @user = User.find(params[:id])
    @connections = @user.connections.paginate(page: params[:page], per_page: 30)
  end

  def edit
    @user = User.find(params[:id])
  end

  def administration
    @user = User.find(params[:id])
    @courses = @user.course_ownerships
    @problems = @user.problem_ownerships
    @assignments = @user.assignment_ownerships
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end


  private  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  private def correct_user
    @user = User.find(params[:id])
    if current_user?(@user)
      true
    else
      flash[:danger] = "You do not have access to view page"
      redirect_to(root_url)
    end
  end

  private def admin_user
    if current_user.admin?
      true
    else
      flash[:danger] = "Must have admin privilege to view page"
      redirect_to(root_url)
    end
  end
end
