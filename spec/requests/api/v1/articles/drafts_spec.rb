require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    let!(:drafts) { create_list(:article, 3, user: current_user, status: "draft") }
    let!(:articles) { create_list(:article, 5, user: current_user, status: "published") }
    let!(:drafts_by_other_user) { create_list(:article, 7, user: other_user, status: "draft") }
    let!(:drafts_by_other_user) { create_list(:article, 9, user: other_user, status: "published") }
    let(:current_user) { create(:user) }
    let(:other_user) {create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "自分の下書き記事一覧を取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
      expect(response).to have_http_status(:ok)
    end
  end
end