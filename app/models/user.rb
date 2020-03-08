# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }
  validates :account, presence: true, length: { maximum: 50 }
  # 正規表現 「.」を２回以上繰り返さないように設定　例）foo@bar..com
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    uniqueness: true,
                    format: { with: VALID_EMAIL_REGEX }
end
