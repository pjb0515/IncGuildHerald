class GuildRpSnapshot < ActiveRecord::Base
  belongs_to :guild
  
  def self.create_with_validation(current_guild)
    today = Date.current
    
    if current_guild.rp_snapshots.where(:snapshot_date => today).blank?
      GuildRpSnapshot.create(:guild => current_guild, :total_rps => current_guild.total_rps, :snapshot_date => today)
    end
  end
end
