class Project < ActiveRecord::Base

  has_many :project_tasks, inverse_of: :project
  has_many :tasks, through: :project_tasks

  belongs_to :user

  validates :name, presence: true

end
