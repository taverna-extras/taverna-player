class AddStopToTavernaPlayerRuns < ActiveRecord::Migration
  def change
    add_column :taverna_player_runs, :stop, :boolean, :default => false
  end
end
