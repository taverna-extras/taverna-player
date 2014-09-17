class CreateTavernaPlayerWorkflows < ActiveRecord::Migration
  def change
    create_table :taverna_player_workflows do |t|
      t.string :title
      t.string :author
      t.text :description
      t.string :file

      t.timestamps
    end
  end
end
