class Api::V1::Current::ArticlePreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at
  belongs_to :user, serializer: UserSerializer
end