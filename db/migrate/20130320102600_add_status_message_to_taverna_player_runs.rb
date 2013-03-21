class AddStatusMessageToTavernaPlayerRuns < ActiveRecord::Migration
  def change
    add_column :taverna_player_runs, :status_message, :string
  end
end
