require "rails_helper"

RSpec.describe User, type: :model do
  describe "正常系テスト" do
    context "name, account, email, password が入力されている" do
      let(:user) { build(:user) }
      it "ユーザーが作られる" do
        expect(user.valid?).to eq true
      end
    end
  end

  describe "異常系テスト" do
    describe "accountについて" do
      context "accountを入力していないとき" do
        let(:user) { build(:user, account: nil) }
        it "エラーする" do
          user.valid?
          expect(user.errors.messages[:account]).to include "can't be blank"
        end
      end

      context "accountが51字以上のとき" do
        let(:user) { build(:user, account: "a" * 51) }
        it "エラーする" do
          user.valid?
          expect(user.errors.messages[:account]).to include "is too long (maximum is 50 characters)"
        end
      end
    end

    describe "nameについて" do
      context "nameを入力していないとき" do
        let(:user) { build(:user, name: nil) }
        it "エラーする" do
          user.valid?
          expect(user.errors.messages[:name]).to include "can't be blank"
        end
      end

      context "nameが51字以上のとき" do
        let(:user) { build(:user, name: "a" * 51) }
        it "エラーする" do
          user.valid?
          expect(user.errors.messages[:name]).to include "is too long (maximum is 50 characters)"
        end
      end
    end

    describe "emailについて" do
      context "emailを入力していないとき" do
        let(:user) { build(:user, email: nil) }
        it "エラーする" do
          user.valid?
          expect(user.errors.messages[:email]).to include "can't be blank"
        end
      end

      context "同名のemailが存在するとき" do
        before { create(:user, email: "neko@example.com") }

        let(:user) { build(:user, email: "neko@example.com") }
        it "エラーする" do
          user.valid?
          expect(user.errors.messages[:email]).to include "has already been taken"
        end
      end
    end

    describe "passwordについて" do
      context "passwordを入力していないとき" do
        let(:user) { build(:user, password: nil) }
        it "エラーする" do
          user.valid?
          expect(user.errors.messages[:password]).to include "can't be blank"
        end
      end

      context "passwordが6字未満のとき" do
        let(:user) { build(:user, password: "a" * 5) }
        it "エラーする" do
          user.valid?
          expect(user.errors.messages[:password]).to include "is too short (minimum is 6 characters)"
        end
      end

      context "passwordが129字以上のとき" do
        let(:user) { build(:user, password: "a" * 129) }
        it "エラーする" do
          user.valid?
          expect(user.errors.messages[:password]).to include "is too long (maximum is 128 characters)"
        end
      end
    end
  end
end
