class Task < ActiveRecord::Base

  has_many :project_tasks, inverse_of: :task
  has_many :projects, through: :project_tasks

  belongs_to :user

  validates :name, presence: true

  def self.overdue
    self.all.where('completed = ? AND DATE(complete_by) < ?', false, Date.today)
  end

  def add_project(project)
    projects << project if project && !projects.include?(project)
  end

end
