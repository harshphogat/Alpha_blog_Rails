class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update]
  

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 4)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 4)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to the Alpha Blog #{@user.username}, you have successfully signed up."
      redirect_to articles_path

    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Your account information is updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    return nil unless current_user == @user || current_user.admin?

    @user.destroy
    session[:user_id] = nil if @user == current_user
    flash[:notice] = 'Account and all associated articles successfully deleted'
    redirect_to root_path
  end

  def follow
    @user = User.find(params[:format])
    current_user.followings << @user
    redirect_to users_path
  end

  def unfollow
    @user = User.find(params[:format])
    @unfollow = Follow.where(follower_id: current_user.id, followed_user_id: @user.id).first
    @unfollow.destroy
    redirect_to users_path
  end
  
  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    return nil unless current_user != @user
    flash[:alert] = 'You can only change or delete your profile'
    redirect_to @user
  end

end
