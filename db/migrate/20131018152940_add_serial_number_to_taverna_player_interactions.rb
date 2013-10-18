class AddSerialNumberToTavernaPlayerInteractions < ActiveRecord::Migration
  def change
    add_column :taverna_player_interactions, :serial, :string
  end
end
