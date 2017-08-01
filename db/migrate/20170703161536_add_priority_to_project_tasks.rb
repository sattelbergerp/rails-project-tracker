class AddPriorityToProjectTasks < ActiveRecord::Migration
  def change
    add_column :project_tasks, :priority, :integer, default: 0
  end
end
