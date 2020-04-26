require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    before do
      create_list(:article, 3, user: current_user, status: "draft")
      create_list(:article, 5, user: current_user, status: "published")
      create_list(:article, 7, user: other_user, status: "draft")
      create_list(:article, 9, user: other_user, status: "published")
    end

    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "自分の下書き記事一覧を取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/articles/drafts:id" do
    subject { get(api_v1_articles_draft_path(article.id), headers: headers) }

    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }

    context "ログインユーザーが、自分の下書き記事詳細を取得する場合" do
      let(:article) { create(:article, user: current_user, status: "draft") }
      let(:headers) { current_user.create_new_auth_token }

      it "取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["status"]).to eq "draft"
      end
    end

    context "ログインユーザーが、他のユーザーの下書き記事詳細を取得する場合" do
      let(:article) { create(:article, user: other_user, status: "draft") }
      let(:headers) { current_user.create_new_auth_token }

      it "取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "他のユーザーが、ログインユーザーの下書き記事詳細を取得する場合" do
      let(:article) { create(:article, user: current_user, status: "draft") }
      let(:headers) { other_user.create_new_auth_token }

      it "取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
