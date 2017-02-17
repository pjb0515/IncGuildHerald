class CreatePlayerRankings < ActiveRecord::Migration
  def change
    create_table :player_rankings do |t|
      t.references :player, index: true, foreign_key: true
      t.integer :rank
      t.integer :rps_gained
      t.integer :rank_type

      t.timestamps null: false
    end
  end
end
