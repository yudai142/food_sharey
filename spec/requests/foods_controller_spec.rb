require 'rails_helper'

RSpec.describe FoodsController, type: :controller do
  describe "#index" do
    it "正常なレスポンスか？" do
      get :index
      expect(response).to be_successful
    end
    it "200レスポンスが返ってきているか？" do
      get :index
      expect(response).to have_http_status "200"
    end
  end
end
