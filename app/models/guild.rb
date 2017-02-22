class Guild < ActiveRecord::Base
  has_many :players
  has_many :guild_rp_snapshots
  
  enum realm: [ :hibernia, :midgard, :albion, "7" ]
  
  def self.find_or_create(guild_name, realm)
    if guild_name.blank?
      return nil
    elsif found_guild = Guild.find_by(:name => guild_name)
      return found_guild
    else
      return create(:name => guild_name, :realm => realm)
    end
  end
  
  def calculate_full_rps_gained()
    #If there are no rp snapshots, dont try and calculate rps gained over time.
    rp_snapshots = guild_rp_snapshots
    if rp_snapshots.blank?
      return nil
    end
    
    update(:last_fourteen_days_rps => calculate_rps_gained(14, rp_snapshots), :last_seven_days_rps => calculate_rps_gained(7, rp_snapshots), :last_three_days_rps => calculate_rps_gained(3, rp_snapshots))
  end
  
  def calculate_rps_gained(amount_of_days, rp_snapshots)
    today = Date.current
    
    calculating_date = today - amount_of_days
    rp_snapshot_list = rp_snapshots.order("snapshot_date ASC")
    rp_snapshot = nil
    
    #find the first snapshot that was saved the amount of days ago or more recently.
    rp_snapshot_list.each do |snapshot|
      if snapshot.snapshot_date >= calculating_date
        rp_snapshot = snapshot
        break
      end
    end
    
    return total_rps - rp_snapshot.total_rps
  end
end
