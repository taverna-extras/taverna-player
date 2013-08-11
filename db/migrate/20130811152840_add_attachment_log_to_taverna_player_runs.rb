class AddAttachmentLogToTavernaPlayerRuns < ActiveRecord::Migration
  def change
    add_attachment :taverna_player_runs, :log
  end
end
