class AddProxyToTavernaPlayerRuns < ActiveRecord::Migration
  def change
    add_column :taverna_player_runs, :proxy_notifications, :string
    add_column :taverna_player_runs, :proxy_interactions, :string
  end
end
