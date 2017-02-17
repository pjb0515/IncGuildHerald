class CreateGuilds < ActiveRecord::Migration
  def change
    create_table :guilds do |t|
      t.string :name
      t.integer :realm
      t.integer :total_rps

      t.timestamps null: false
    end
    
    add_index :guilds, :name, :unique => true
  end
end
