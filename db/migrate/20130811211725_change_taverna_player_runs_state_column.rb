class ChangeTavernaPlayerRunsStateColumn < ActiveRecord::Migration
  def change
    rename_column :taverna_player_runs, :state, :saved_state
  end
end
