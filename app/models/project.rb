class Project < ActiveRecord::Base

  has_many :project_tasks, inverse_of: :project
  has_many :tasks, through: :project_tasks

  has_many :messages, class_name: 'ProjectMessage'

  belongs_to :user

  validates :name, presence: true

  accepts_nested_attributes_for :messages

end
