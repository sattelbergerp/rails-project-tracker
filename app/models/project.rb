class Project < ActiveRecord::Base

  has_many :project_tasks, inverse_of: :project
  has_many :tasks, through: :project_tasks

  has_many :messages, class_name: 'ProjectMessage'

  belongs_to :user

  validates :name, presence: true

  def tasks_by_priority()
    #Array must ber compacted to remove trailing nil value
    return project_tasks.order("project_tasks.priority DESC").collect {|v|v.task}.compact
  end

  def messages_attributes=(messages_attrs)
    messages.destroy_all
    messages_attrs.each do |key, message_hash|
      messages.build(message_hash) if message_hash[:message_type] && !message_hash[:message_type].empty?
    end
  end

  def next_id
    id = self.id+1
    max_id = nil;
    while true
      break if user.projects.exists?(id: id)
      id+=1
      max_id = user.projects.maximum(:id) unless max_id
      if id > max_id
        id=nil
        break
      end
    end
    id
  end

  def prev_id
    id = self.id-1
    while true
      break if user.projects.exists?(id: id)
      id-=1
      if id < 1
        id=nil
        break
      end
    end
    id
  end

end
