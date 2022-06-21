class UsersController < ApplicationController
  protect_from_forgery
  skip_before_action :require_login, only: [:new,:create]
  
  def new
    if logged_in?
      redirect_to(root_path, notice: '既にログインしています')
    end
    @user = User.new
  end

  def create
    if logged_in?
      redirect_to(root_path, notice: '既にログインしています')
    end
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path
      flash[:notice] = 'ユーザーの作成に成功しました'
    else
      flash.now[:alert] = 'ユーザーの作成に失敗しました'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :food_ideas_hide, :user_ranking_hide, :release)
  end
end
