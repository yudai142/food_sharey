class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :destroy, :guest_login]
  def new
    (redirect_to root_path, notice: '既にログインしています'; return) if logged_in?
  end

  def create
    (redirect_to root_path, notice: '既にログインしています'; return) if logged_in?
    @user = login(params[:email], params[:password], true)
    if @user
      redirect_back_or_to(foods_path, notice: 'ログインに成功しました')
    else
      flash.now[:alert] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    (redirect_to root_path; return) unless logged_in?
    logout
    redirect_to(root_path, notice: 'ログアウトしました')
  end

  def guest_login
    (redirect_to root_path, alert: 'すでにログインしています'; return) if logged_in?
    @guest_user = User.guest_new
    auto_login(@guest_user)
    redirect_to foods_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end
