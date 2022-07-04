require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    # factoriesで作成したダミーデータを使用します。
    let(:user) { FactoryBot.create(:user) }
    # let!(:post) { build(:post, user_id: user.id) }

    # test_postを作成し、空欄での登録ができるか確認します。
    subject { user.valid? }
    # let(:test_user) { user }


    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false;
      end
      it '20文字以下であること' do
        user.name = Faker::Lorem.characters(number:22)
        is_expected.to eq false;
      end
    end
    
    context "空の場合" do
      let(:user){User.new(name:"")} #titleが空文字のTodoオブジェクトを生成

      it "エラーを返す" do
        user.valid? #バリデーションを実行
        expect(user.errors[:name]).to be_present #期待結果：エラーメッセージが存在する
      end
    end

    context "Nullの場合" do
      let(:user){User.new(name:nil)} #titleがNullのTodoオブジェクトを生成

      it "エラーを返す" do
        user.valid? #バリデーションを実行
        expect(user.errors[:name]).to be_present #期待結果：エラーメッセージが存在する
      end
    end

    context "値が入っている場合" do
      let(:user){User.new(name:"this is title")} #titleに値が入っているTodoオブジェクトを生成

      it "エラーを返さない" do
        user.valid? #バリデーションを実行
        expect(user.errors[:name]).to be_blank #期待結果：エラーメッセージが存在しない
      end
    end
  end
  # describe 'アソシエーションのテスト' do
  #   context 'customerモデルとの関係' do
  #     it 'N:1となっている' do
  #       expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
  #     end
  #   end

  #   has_manyの関係性で記述するのもありです。
  #   context 'PostCommentモデルとの関係' do
  #     it '1:Nとなっている' do
  #       expect(Post.reflect_on_association(:post_comments).macro).to eq :has_many
  #     end
  #   end
  # end
end
