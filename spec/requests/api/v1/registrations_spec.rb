require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "正しい情報が送られたとき" do
      let(:params) { attributes_for(:user) }

      it "ユーザー登録できる" do
        expect { subject }.to change { User.count }.by(1)
        headers = response.headers
        expect(headers["uid"]).to be_present
        expect(headers["client"]).to be_present
        expect(headers["access-token"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "emailがnilの場合" do
      let(:params) { attributes_for(:user, email: nil) }

      it "ユーザー登録できない" do
        expect { subject }.to change { User.count }.by(0)
        headers = response.headers
        expect(headers["uid"]).to be nil
        expect(headers["client"]).to be nil
        expect(headers["access-token"]).to be nil
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "nameがnilの場合" do
      let(:params) { attributes_for(:user, name: nil) }

      it "ユーザー登録できない" do
        expect { subject }.to change { User.count }.by(0)
        headers = response.headers
        expect(headers["uid"]).to be nil
        expect(headers["client"]).to be nil
        expect(headers["access-token"]).to be nil
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "passwordがnilの場合" do
      let(:params) { attributes_for(:user, password: nil) }

      it "ユーザー登録できない" do
        expect { subject }.to change { User.count }.by(0)
        headers = response.headers
        expect(headers["uid"]).to be nil
        expect(headers["client"]).to be nil
        expect(headers["access-token"]).to be nil
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "正しい情報が送られたとき" do
      let!(:user) { create(:user) }
      let(:params) { { email: user.email, password: user.password } }

      it "ログインできる" do
        subject
        headers = response.headers
        expect(headers["uid"]).to be_present
        expect(headers["client"]).to be_present
        expect(headers["access-token"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "emailが間違っていたとき" do
      let!(:user) { create(:user) }
      let(:params) { { email: Faker::Internet.email, password: user.password } }

      it "ログインできない" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "passwordが間違っていたとき" do
      let!(:user) { create(:user) }
      let(:params) { { email: user.email, password: Faker::Internet.password(min_length: 6, max_length: 128) } }

      it "ログインできない" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context "正しい情報が送られたとき" do
      let!(:user) { create(:user) }
      let(:headers) { user.create_new_auth_token }

      it "ログアウトできる" do
        subject
        headers = response.headers
        expect(headers["uid"]).to be nil
        expect(headers["client"]).to be nil
        expect(headers["access-token"]).to be nil
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
