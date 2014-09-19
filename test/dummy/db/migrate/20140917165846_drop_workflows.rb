class DropWorkflows < ActiveRecord::Migration
  def up
    drop_table :workflows
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
