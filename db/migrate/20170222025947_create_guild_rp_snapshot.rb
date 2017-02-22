class CreateGuildRpSnapshot < ActiveRecord::Migration
  def change
    create_table :guild_rp_snapshots do |t|
      
      t.references :guild, index: true, foreign_key: true
      t.date :snapshot_date
      t.integer :total_rps

      t.timestamps null: false
    end
    
    add_column :guilds, :last_three_days_rps, :integer, default: 0
    add_column :guilds, :last_seven_days_rps, :integer, default: 0
    add_column :guilds, :last_fourteen_days_rps, :integer, default: 0
  end
end
