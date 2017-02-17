class CreateRpSnapshots < ActiveRecord::Migration
  def change
    create_table :rp_snapshots do |t|
      t.references :player, index: true, foreign_key: true
      t.date :snapshot_date
      t.integer :rp_total

      t.timestamps null: false
    end
  end
end
