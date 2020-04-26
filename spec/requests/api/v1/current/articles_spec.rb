require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    before do
      create_list(:article, 3, user: current_user, status: "draft")
      create_list(:article, 5, user: current_user, status: "published")
      create_list(:article, 7, user: other_user, status: "draft")
      create_list(:article, 9, user: other_user, status: "published")
    end

    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "記事一覧（ステータスが公開）を取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 5
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
      expect(response).to have_http_status(:ok)
    end
  end
end