class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_many :tasks_by_priority, key: 'tasks'
  has_many :messages
end
