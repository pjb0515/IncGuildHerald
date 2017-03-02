include  ActionView::Helpers::NumberHelper

class Player < ActiveRecord::Base
  belongs_to :guild
  has_many :rp_snapshots

	enum race: [ :celt, :elf, :firbolg, :lurikeen, :sylvan, :dwarf, :kobold, :norseman, :troll, :valkyn, :briton, :saracen, :avalonian, :highlander, :inconnu ]
	enum daoc_class: [ :animist, :bard, :blademaster, :champion, :druid, :eldritch, :enchanter, :hero, :mentalist, :nightshade, :ranger, :valewalker, :warden, :naturalist, :stalker, :guardian, :magician, :forester, :berserker, :bonedancer, :healer, :hunter, :runemaster, :savage, :shadowblade, :shaman, :skald, :spiritmaster, :thane, :warrior, :viking, :seer, :mystic, :midgardrogue, :armsman, :cabalist, :cleric, :friar, :infiltrator, :mercenary, :minstrel, :necromancer, :paladin, :reaver, :scout, :sorcerer, :theurgist, :wizard, :fighter, :acolyte, :albionrogue, :mage, :elementalist, :disciple ]
	enum realm: [ :hibernia, :midgard, :albion, "7" ]
  
  def self.update_player(name, guild_name, race, daoc_class, realm, level, realm_level, total_rps, last_update)
    current_player = nil
    player_guild = nil
    
    player_guild = Guild.find_or_create(guild_name, realm)
    
    #Player exists in the database, so update any attributes that have changed.
    if current_player = Player.find_by(:name => name)
      current_player.update(:guild => player_guild, :race => race, :daoc_class => daoc_class, :realm => realm, :level => level, :realm_level => realm_level, :total_rps => total_rps, :last_api_update => last_update)
    
      current_player.calculate_full_rps_gained()
      
    #else create new player
    else
      current_player = Player.new(:name => name, :guild => player_guild, :race => race, :daoc_class => daoc_class, :realm => realm, :level => level, :realm_level => realm_level, :total_rps => total_rps, :last_api_update => last_update)
      current_player.save
    end
    
    RpSnapshot.create_with_validation(current_player)
    return current_player
  end
  
  def self.get_top_players(realm, duration, daoc_class)
    where_statement = nil
    if realm.blank? or realm.eql? "all-realms"
      where_statement = Player.all
    else
      if daoc_class.eql? "all-classes"
        where_statement = where(realm: realms[realm])
      else
        where_statement = where(realm: realms[realm], daoc_class: daoc_class)
      end
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
  
  def self.hibernia_rps(duration)
    Rails.cache.fetch("hibernia_rps/"+duration, expires_in: 20.minutes) do
      Player.where(:realm => 0).sum(duration)
    end
  end
  
  def self.midgard_rps(duration)
    Rails.cache.fetch("midgard_rps/"+duration, expires_in: 20.minutes) do
      Player.where(:realm => 1).sum(duration)
    end
  end
  
  def self.albion_rps(duration)
    Rails.cache.fetch("albion_rps/"+duration, expires_in: 20.minutes) do
      Player.where(:realm => 3).sum(duration)
    end
  end
  
  def self.number_of_50s(realm)
    Rails.cache.fetch("number_of_50s/"+realm, expires_in: 20.minutes) do
      Player.where(realm: Player.realms[realm], level: 50).count
    end
  end
  
  def self.number_of_players_made(realm)
    Rails.cache.fetch("number_of_50s/"+realm, expires_in: 20.minutes) do
      Player.where(realm: Player.realms[realm]).count
    end
  end
  
  def get_guild_name
    if guild.nil?
      ""
    else
      return guild.name
    end
  end
  
  def calculate_full_rps_gained()
    #If there are no rp snapshots, dont try and calculate rps gained over time.
    player_rp_snapshots = rp_snapshots
    if player_rp_snapshots.blank?
      return nil
    end
    
    update(:last_fourteen_days_rps => calculate_rps_gained(14, player_rp_snapshots), :last_seven_days_rps => calculate_rps_gained(7, player_rp_snapshots), :last_three_days_rps => calculate_rps_gained(3, player_rp_snapshots))
  end
  
  def calculate_rps_gained(amount_of_days, player_rp_snapshots)
    today = Date.current
    
    calculating_date = today - amount_of_days
    rp_snapshot_list = player_rp_snapshots.order("snapshot_date ASC")
    rp_snapshot = nil
    
    #find the first snapshot that was saved the amount of days ago or more recently.
    rp_snapshot_list.each do |snapshot|
      if snapshot.snapshot_date >= calculating_date
        rp_snapshot = snapshot
        break
      end
    end
    
    rps_gained = 0
    
    if !rp_snapshot.nil?
      rps_gained = total_rps - rp_snapshot.total_rps
    end
    return rps_gained
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
    #Ranking only calculated for characters 45 and above
    if level < 45
      return "N/A"
    end
    
    player_list = nil
    if duration.eql? "overall"
      player_list = Player.where(level: 45..50).order('total_rps DESC')
    else
      player_list = Player.where(level: 45..50).order(duration+' DESC')
    end
    player_list.map(&:id).index(id)+1
  end
  
  def get_rank_in_realm(duration)
    #Ranking only calculated for characters 45 and above
    if level < 45
      return "N/A"
    end
    
    player_list = nil
    if duration.eql? "overall"
      player_list = Player.where(realm: realm, level: 45..50).order('total_rps DESC')
    else
      player_list =  Player.where(realm: realm, level: 45..50).order(duration+' DESC')
    end
    player_list.map(&:id).index(id)+1
  end

  def format_rr()
    rr = realm_level.to_s.scan(/(\d{1,2})(\d)/);
    return rr.join('L');
  end

  def format_realm_points(rps)
    number_with_delimiter(rps, :delimiter => ',')
  end
end