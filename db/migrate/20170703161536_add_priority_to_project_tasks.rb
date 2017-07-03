class AddPriorityToProjectTasks < ActiveRecord::Migration
  def change
    add_column :project_tasks, :priority, :integer
  end
end
