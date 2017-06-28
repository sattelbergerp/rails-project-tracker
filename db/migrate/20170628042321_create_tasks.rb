class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.date :complete_by
      t.boolean :completed
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
