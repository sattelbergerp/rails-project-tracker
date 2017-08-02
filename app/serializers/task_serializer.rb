class TaskSerializer < ActiveModel::Serializer
  #Otherwise we can't use url helpers
  include Rails.application.routes.url_helpers

  attributes :id, :name, :description, :complete_by, :completed, :created_at, :updated_at
  attribute :html_url do
    task_path(object.id)
  end
end
