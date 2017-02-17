class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :level
      t.integer :realm_level
      t.timestamp :last_api_update
      t.integer :race
      t.integer :class
      t.integer :realm
      t.integer :total_rps
      t.references :guild, index: true, foreign_key: true

      t.timestamps null: false
    end
    
    add_index :players, :name, :unique => true
  end
end
