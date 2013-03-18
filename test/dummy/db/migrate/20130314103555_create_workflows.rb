class CreateWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows do |t|
      t.string :title
      t.string :author
      t.text :description
      t.string :file

      t.timestamps
    end
  end
end
