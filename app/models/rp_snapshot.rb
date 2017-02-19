class RpSnapshot < ActiveRecord::Base
  belongs_to :player
  
  #Only create an RP snapshot for players above level 44
  def self.create_with_validation(current_player)
    today = Date.current
    
    if current_player.level >= 45 and current_player.rp_snapshots.where(:snapshot_date => today).blank?
      RpSnapshot.create(:player => current_player, :total_rps => current_player.total_rps, :snapshot_date => today)
    end
  end
end
