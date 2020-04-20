class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
  belongs_to :user
  enum status: { draft: 0, published: 1, deleted: 2 }
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true
  validates :status, inclusion: { in: Article.statuses.keys }
end
