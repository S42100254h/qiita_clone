require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    before do
      create_list(:article, 1, :draft, user: current_user)
      create_list(:article, 2, :published, user: current_user)
      create_list(:article, 4, :draft, user: other_user)
      create_list(:article, 8, :published, user: other_user)
    end

    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "記事一覧（ステータスが公開）を取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 2
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
      expect(response).to have_http_status(:ok)
    end
  end
end
