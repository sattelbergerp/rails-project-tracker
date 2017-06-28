class CreateProjectMessages < ActiveRecord::Migration
  def change
    create_table :project_messages do |t|
      t.string :message_type
      t.string :content
      t.string :project_id

      t.timestamps null: false
    end
  end
end
