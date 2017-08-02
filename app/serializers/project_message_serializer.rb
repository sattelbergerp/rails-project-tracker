class ProjectMessageSerializer < ActiveModel::Serializer
  attributes :message_type, :content
end
