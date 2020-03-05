class Article < ApplicationRecord
  has_many :comment, dependent: :destroy
  has_many :article_like, dependent: :destroy
  belongs_to :user
end
