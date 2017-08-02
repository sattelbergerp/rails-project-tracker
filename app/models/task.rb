class Task < ActiveRecord::Base

  has_many :project_tasks, inverse_of: :task
  has_many :projects, through: :project_tasks

  belongs_to :user

  validates :name, presence: true

  def self.overdue
    self.all.where('completed = ? AND DATE(complete_by) < ?', false, Date.today)
  end

  def self.completed
    self.all.where('completed = ?', true)
  end

  def self.not_completed
    self.all.where('completed = ?', false)
  end

  def self.due_today
    self.all.where('completed = ? AND DATE(complete_by) = ?', false, Date.today)
  end

  def add_project(project)
    projects << project if project && !projects.include?(project)
  end

end
