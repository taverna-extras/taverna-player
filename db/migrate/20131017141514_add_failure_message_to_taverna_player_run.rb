class AddFailureMessageToTavernaPlayerRun < ActiveRecord::Migration
  def change
    add_column :taverna_player_runs, :failure_message, :text
  end
end
