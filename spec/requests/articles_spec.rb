require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    before do
      create_list(:article, 3)
      create_list(:article, 5, status: "draft")
    end

    it "記事一覧（ステータスが公開）を取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidの記事が存在する場合" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it "記事を取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "指定したidの記事が存在しない場合" do
      let(:article_id) { 11111 }

      it "記事を取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "current_userに紐づけられた記事を作成できる" do
      expect { subject }.to change { current_user.articles.count }.by(1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: { title: Faker::Lorem.characters(number: Random.new.rand(1..50)), created_at: Time.current } } }
    let(:article) { create(:article, user: current_user) }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "current_userに紐づけられた記事を更新できる" do
      expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                            not_change { article.reload.body } &
                            not_change { article.reload.created_at }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article.id), headers: headers) }

    let!(:article) { create(:article, user: current_user) }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "current_userに紐づけられた記事を削除できる" do
      expect { subject }.to change { current_user.articles.count }.by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end
