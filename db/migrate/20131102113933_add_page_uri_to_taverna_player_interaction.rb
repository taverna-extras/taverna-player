class AddPageUriToTavernaPlayerInteraction < ActiveRecord::Migration
  def change
    add_column :taverna_player_interactions, :page_uri, :string
  end
end
