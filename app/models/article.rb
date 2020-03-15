class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
  belongs_to :user
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true
end
