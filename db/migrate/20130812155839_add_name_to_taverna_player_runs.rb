class AddNameToTavernaPlayerRuns < ActiveRecord::Migration
  def change
    add_column :taverna_player_runs, :name, :string, :default => "None"
  end
end
