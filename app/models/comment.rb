class Comment < ApplicationRecord
  has_many :comment_like, dependent: :destroy
  belongs_to :user
  belongs_to :article
end
