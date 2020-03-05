# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  has_many :article, dependent: :destroy
  has_many :comment, dependent: :destroy
  has_many :article_like, dependent: :destroy
  has_many :comment_like, dependent: :destroy
end
