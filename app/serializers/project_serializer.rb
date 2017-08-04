class ProjectSerializer < ActiveModel::Serializer

  #Otherwise we can't use url helpers
  include Rails.application.routes.url_helpers

  attributes :id, :name, :description
  attribute :next_id do
    object.next_id
  end
  attribute :prev_id do
    object.prev_id
  end
  attribute :links do
    {
      edit: edit_project_path(object),
      self: project_path(object)
    }
  end
  has_many :tasks_by_priority, key: 'tasks'
  has_many :messages
end
