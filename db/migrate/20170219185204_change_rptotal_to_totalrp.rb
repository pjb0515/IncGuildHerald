class ChangeRptotalToTotalrp < ActiveRecord::Migration
  def change
    remove_column :rp_snapshots, :rp_total
    add_column :rp_snapshots, :total_rp, :integer
  end
end
