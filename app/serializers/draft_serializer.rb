class DraftSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :status
  belongs_to :user
end
