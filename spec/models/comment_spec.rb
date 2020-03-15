require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "正常系テスト" do
    context "bodyが入力されている" do
      let(:comment) { build(:comment) }
      it "commentが作られる" do
        expect(comment.valid?).to eq true
      end
    end
  end

  describe "異常系テスト" do
    context "bodyが入力されていない" do
      let(:comment) { build(:comment, body: nil) }
      it "エラーする" do
        comment.valid?
        expect(comment.errors.messages[:body]).to include "can't be blank"
      end
    end
  end
end
