require 'rails_helper'

RSpec.describe "userテスト", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザーが新規登録できるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移行する' do
      # トップページに移動する
      visit root_path
      # トップページへサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      visit new_user_path
      # ユーザー情報を入力する
      fill_in 'user[name]', with: @user.name
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      fill_in 'user[password_confirmation]', with: @user.password_confirmation
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{find('input[name="commit"]').click}.to change { User.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      expect(page).to have_content('ログアウト')
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
      expect(page).to have_selector('.notice', text: 'ユーザーの作成に成功しました')
    end
  end
  
  describe 'ログイン処理' do
    before do
      User.create!(
        name: "Yamada Taro",
        email: "taro@example.com",
        password: 'password',
        password_confirmation: 'password'
      )
    end
  
    it 'ユーザー認証成功' do
      visit root_path
      expect(page).to have_content('ログイン')
      visit login_path
      fill_in 'email', with: 'taro@example.com'
      fill_in 'password', with: 'password'
      click_button 'ログイン'
      expect(current_path).to eq(foods_path)
      expect(page).to have_content('ログアウト')
      expect(page).to have_selector('.notice', text: 'ログインに成功しました')
    end
  
    it 'ユーザー認証失敗' do
      visit root_path
      expect(page).to have_content('ログイン')
      visit login_path
      fill_in 'email', with: 'taro'
      fill_in 'password', with: 'wrong_password'
      click_button 'ログイン'
      expect(current_path).to eq(login_path)
      expect(page).to have_selector('.alert', text: 'ログインに失敗しました')
    end
  end
  
  describe 'ログアウト処理' do
    before do
      User.create!(
        name: "Yamada Taro",
        email: "taro@example.com",
        password: 'password',
        password_confirmation: 'password'
      )
      visit login_path
      fill_in 'email', with: 'taro@example.com'
      fill_in 'password', with: 'password'
      click_button 'ログイン'
    end
  
    it '正常にログアウトできるか' do
      visit root_path
      expect(page).to have_content('ログアウト')
      click_link 'ログアウト'
      expect(current_path).to eq(root_path)
      expect(page).to have_content('新規登録')
      expect(page).to have_content('ログイン')
      expect(page).to have_selector('.notice', text: 'ログアウトしました')
    end
  end
end
