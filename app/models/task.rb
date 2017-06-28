class Task < ActiveRecord::Base

  has_many :project_tasks, inverse_of: :task
  has_many :projects, through: :project_tasks

  belongs_to :user

  validates :name, presence: true

  def validate_project_count
    if projects.count > 0
      return true
    else
      errors[:projects] << 'must contain at least one project'
      return false
    end
  end

end
