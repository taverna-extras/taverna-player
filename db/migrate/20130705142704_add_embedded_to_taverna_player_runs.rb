class AddEmbeddedToTavernaPlayerRuns < ActiveRecord::Migration
  def change
    add_column :taverna_player_runs, :embedded, :boolean, :default => false
  end
end
