class ChangeTavernaPlayerInteractionsOutputValueColumnName < ActiveRecord::Migration
  def change
    rename_column :taverna_player_interactions, :output_value, :data
  end
end
