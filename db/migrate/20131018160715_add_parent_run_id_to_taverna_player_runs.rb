class AddParentRunIdToTavernaPlayerRuns < ActiveRecord::Migration
  def change
    add_column :taverna_player_runs, :parent_id, :integer
  end
end
