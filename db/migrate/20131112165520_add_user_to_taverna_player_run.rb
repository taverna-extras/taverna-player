class AddUserToTavernaPlayerRun < ActiveRecord::Migration
  def change
    add_column :taverna_player_runs, :user_id, :integer
  end
end
