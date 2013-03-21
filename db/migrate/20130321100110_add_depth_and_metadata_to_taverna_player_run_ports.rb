class AddDepthAndMetadataToTavernaPlayerRunPorts < ActiveRecord::Migration
  def change
    add_column :taverna_player_run_ports, :depth, :integer, :default => 0
    add_column :taverna_player_run_ports, :metadata, :text
  end
end
