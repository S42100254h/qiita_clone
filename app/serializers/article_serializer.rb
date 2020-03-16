class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user
  belongs_to :user
end
