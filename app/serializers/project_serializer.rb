class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  attribute :next_id do
    id = object.id+1
    max_id = nil;
    while true
      break if object.user.projects.exists?(id: id)
      id+=1
      max_id = object.user.projects.maximum(:id) unless max_id
      if id > max_id
        id=nil
        break
      end
    end
    id
  end
  attribute :prev_id do
    id = object.id-1
    while true
      break if object.user.projects.exists?(id: id)
      id-=1
      if id < 1
        id=nil
        break
      end
    end
    id
  end
  has_many :tasks_by_priority, key: 'tasks'
  has_many :messages
end
