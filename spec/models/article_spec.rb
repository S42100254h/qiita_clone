require "rails_helper"

RSpec.describe Article, type: :model do
  describe "正常系テスト" do
    context "title, body が入力されている" do
      let(:article) { build(:article) }
      it "記事が作られる" do
        expect(article.valid?).to eq true
      end
    end
  end

  describe "異常系テスト" do
    describe "titleについて" do
      context "titleを入力していないとき" do
        let(:article) { build(:article, title: nil) }
        it "エラーする" do
          article.valid?
          expect(article.errors.messages[:title]).to include "can't be blank"
        end
      end

      context "titleが51字以上のとき" do
        let(:article) { build(:article, title: "a" * 51) }
        it "エラーする" do
          article.valid?
          expect(article.errors.messages[:title]).to include "is too long (maximum is 50 characters)"
        end
      end
    end

    describe "body" do
      context "bodyを入力していないとき" do
        let(:article) { build(:article, body: nil) }
        it "エラーする" do
          article.valid?
          expect(article.errors.messages[:body]).to include "can't be blank"
        end
      end
    end
  end
end
