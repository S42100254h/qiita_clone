class UserSerializer < ActiveModel::Serializer
  attributes :id, :account
  has_many :articles
end
