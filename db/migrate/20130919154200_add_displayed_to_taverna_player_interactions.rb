class AddDisplayedToTavernaPlayerInteractions < ActiveRecord::Migration
  def change
    add_column :taverna_player_interactions, :displayed, :boolean, :default => false
  end
end
