class AddAttachmentResultsToTavernaPlayerRuns < ActiveRecord::Migration
  def change
    add_attachment :taverna_player_runs, :results
  end
end
