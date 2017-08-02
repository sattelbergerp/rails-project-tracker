class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :complete_by, :completed, :created_at, :updated_at
end
