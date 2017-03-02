include  ActionView::Helpers::NumberHelper

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
      return create(:name => guild_name, :realm => realm, :total_rps => 0, :last_three_days_rps => 0, :last_seven_days_rps => 0, :last_fourteen_days_rps => 0 )
    end
  end
  
  def self.get_top_guilds(realm, duration)
    where_statement = nil
    if realm.blank? or realm.eql? "all-realms"
      where_statement = Guild.all
    else
      where_statement = where(realm: realms[realm])
    end
    
    if duration.eql? "all-time"
      where_statement = where_statement.order("total_rps DESC")
    elsif duration.eql? "three-days"
      where_statement = where_statement.order("last_three_days_rps DESC")
    elsif duration.eql? "seven-days"
      where_statement = where_statement.order("last_seven_days_rps DESC")
    elsif duration.eql? "fourteen-days"
      where_statement = where_statement.order("last_fourteen_days_rps DESC")
    end
    
    return where_statement.limit(25)
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
  
  def temp_calculate_full_rps_gained
    if players.blank?
      return nil
    end
    update(total_rps: players.sum(:total_rps), last_three_days_rps: players.sum(:last_three_days_rps), last_seven_days_rps: players.sum(:last_seven_days_rps), last_fourteen_days_rps: players.sum(:last_fourteen_days_rps))
  end
  
  def get_rps_from_duration(duration)
    if duration.eql? "all-time"
      return total_rps
    elsif duration.eql? "three-days"
      return last_three_days_rps
    elsif duration.eql? "seven-days"
      return last_seven_days_rps
    elsif duration.eql? "fourteen-days"
      return last_fourteen_days_rps
    end
  end
  
  def get_rank(duration)
    guild_list = nil
    if duration.eql? "overall"
      guild_list = Guild.all.order('total_rps DESC')
    else
      guild_list = Guild.all.order(duration+' DESC')
    end
    guild_list.map(&:id).index(id)+1
  end
  
  def get_rank_in_realm(duration)
    guild_list = nil
    if duration.eql? "overall"
      guild_list = Guild.where(realm: realm).order('total_rps DESC')
    else
      guild_list =  Guild.where(realm: realm).order(duration+' DESC')
    end
    guild_list.map(&:id).index(id)+1
  end

  def format_realm_points(rps)
    number_with_delimiter(rps, :delimiter => ',')
  end
end
