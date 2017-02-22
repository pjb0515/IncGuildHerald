class RemovePlayerRankings < ActiveRecord::Migration
  def change
    drop_table :player_rankings
  end
end
