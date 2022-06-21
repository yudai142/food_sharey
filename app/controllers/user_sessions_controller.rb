class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :destroy]
  def new
    if logged_in?
      redirect_to(root_path, notice: '既にログインしています')
    end
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to(foods_path, notice: 'ログインに成功しました')
    else
      flash.now[:alert] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    redirect_to(root_path, notice: 'ログアウトしました')
  end
end
