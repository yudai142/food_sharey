require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'カラムのテスト' do
    before do
      @user = User.create!(
        name: "Yamada Taro",
        email: "taro@example.com",
        password: 'password',
        password_confirmation: 'password'
      )
    end
    
    let(:user) { FactoryBot.build(:user) }
    subject { user.valid?;user.errors[params] }

    context 'nameカラム' do
      let(:params) { :name }
      it '空の場合エラーを返す' do
        user.name = ''
        is_expected.to be_present
      end
      
      it '20文字以上の場合エラーを返す' do
        user.name = Faker::Lorem.characters(number:21) 
        is_expected.to be_present
      end
      
      it "Nullの場合エラーを返す" do
        user.name = nil
        is_expected.to be_present 
      end
      
      it "値が入っている場合エラーを返さない" do
        is_expected.to be_blank 
      end
    end
    
    context 'emailカラム' do
      let(:params) { :email }
      it '空の場合エラーを返す' do
        user.email = ''
        is_expected.to be_present
      end
      
      it "Nullの場合エラーを返す" do
        user.email = nil
        is_expected.to be_present 
      end
      
      it "重複したメールアドレスの場合エラーを返す" do
        user.email = "taro@example.com"
        is_expected.to be_present
      end
      
      it "メールアドレスの一意性の検証" do
        user = User.create(
          name: "Yamada Taro",
          email: "taro@example.com",
          password: 'password',
          password_confirmation: 'password')
        expect(user).to_not be_valid
        expect(user.errors[:email]).to be_present
      end
      
      context "メールアドレスのフォーマットの検証" do
        it "OKの場合" do
          user.email = 'user@example.com'
          expect(user).to be_valid
        end
        
        it "NGの場合" do
          user.email = 'user@example,com'
          expect(user).to_not be_valid
          expect(user.errors[:email]).to be_present
        end
      end
      
      it "値が入っている場合エラーを返さない" do
        is_expected.to be_blank 
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Eatdateモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:eatdates).macro).to eq :has_many
      end
    end
    context 'Mymenusモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:mymenus).macro).to eq :has_many
      end
    end
    context 'MymenuLikesモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:mymenu_likes).macro).to eq :has_many
      end
    end
    context 'EatdateLikesモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:eatdate_likes).macro).to eq :has_many
      end
    end
  end
end
