class CreateProjectTasks < ActiveRecord::Migration
  def change
    create_table :project_tasks do |t|
      t.integer :project_id
      t.integer :task_id

      t.timestamps null: false
    end
  end
end
