require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    before do
      create_list(:article, 3)
    end

    it "記事一覧を取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "body", "user"]
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
    subject { post(api_v1_articles_path, params: params) }

    before do
      allow_any_instance_of(Api::V1::ApiController).to receive(:current_user).and_return(current_user)
    end

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }

    it "current_userに紐づけられた記事を作成できる" do
      expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params) }
        
    before do
      allow_any_instance_of(Api::V1::ApiController).to receive(:current_user).and_return(current_user)
    end
        
    let(:params) { { article: { title: Faker::Lorem.characters(number: Random.new.rand(1..50)), created_at: Time.current } } }
    let(:article) { create(:article, user: current_user) }
    let(:current_user) { create(:user) }
        
    it "current_userに紐づけられた記事を更新できる" do
      expect { subject }.to change { Article.find(article.id).title }.from(article.title).to(params[:article][:title]) &
                            not_change { Article.find(article.id).body } &
                            not_change { Article.find(article.id).created_at }
      expect(response).to have_http_status(:ok)
    end
  end
end
