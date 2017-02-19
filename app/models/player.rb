class Player < ActiveRecord::Base
  belongs_to :guild
  has_many :player_rankings
  has_many :rp_snapshots

	enum race: [ :celt, :elf, :firbolg, :lurikeen, :sylvan, :dwarf, :kobold, :norseman, :troll, :valkyn, :briton, :saracen, :avalonian, :highlander, :inconnu ]
	enum daoc_class: [ :animist, :bard, :blademaster, :champion, :druid, :eldritch, :enchanter, :hero, :mentalist, :nightshade, :ranger, :valewalker, :warden, :naturalist, :stalker, :guardian, :magician, :forester, :berserker, :bonedancer, :healer, :hunter, :runemaster, :savage, :shadowblade, :shaman, :skald, :spiritmaster, :thane, :warrior, :viking, :seer, :mystic, :midgardrogue, :armsman, :cabalist, :cleric, :friar, :infiltrator, :mercenary, :minstrel, :necromancer, :paladin, :reaver, :scout, :sorcerer, :theurgist, :wizard, :fighter, :acolyte, :albionrogue, :mage, :elementalist, :disciple ]
	enum realm: [ :hibernia, :midgard, :albion, "7" ]
  
  def self.update_player(name, guild_name, race, daoc_class, realm, level, realm_level, total_rps, last_update)
    current_player = nil
    player_guild = nil
    
    player_guild = Guild.find_or_create(guild_name, realm)
    
    #Create a new player
    if !Player.exists?(:name => name)
      current_player = Player.new(:name => name, :guild => player_guild, :race => race, :daoc_class => daoc_class, :realm => realm, :level => level, :realm_level => realm_level, :total_rps => total_rps, :last_api_update => last_update)
      current_player.save
    
    #else player exists in the database, so update any attributes that have changed.
    else
      current_player = Player.find_by(:name => name)
      current_player.update(:guild => player_guild, :race => race, :daoc_class => daoc_class, :realm => realm, :level => level, :realm_level => realm_level, :total_rps => total_rps, :last_api_update => last_update)
    
      current_player.calculate_full_rps_gained()
    end
    
    RpSnapshot.create_with_validation(player)
    return current_player
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
    if rp_snapshots.blank?
      return nil
    end
    
    update(:last_fourteen_days_rps => calculate_rps_gained(14))
    update(:last_seven_days_rps => calculate_rps_gained(7))
    update(:last_three_days_rps => calculate_rps_gained(3))
  end
  
  def calculate_rps_gained(amount_of_days)
    today = Date.current
    rp_snapshot = nil
    
    for i in amount_of_days..0
      rp_snapshot = rp_snapshots.where(:snapshot_date => (today-i))
      
      if !rp_snapshot.blank?
        break
      end
    end
    
    return total_rps - rp_snapshot.total_rps
  end
end