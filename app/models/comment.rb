class Comment < ApplicationRecord
  has_many :comment_likes, dependent: :destroy
  belongs_to :user
  belongs_to :article
  validates :body, presence: true
end
