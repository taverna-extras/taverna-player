class AddAttachmentFileToTavernaPlayerRunPorts < ActiveRecord::Migration
  def change
    remove_column :taverna_player_run_ports, :file
    add_attachment :taverna_player_run_ports, :file
  end
end
