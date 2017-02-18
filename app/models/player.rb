class Player < ActiveRecord::Base
  belongs_to :guild
  has_many :player_rankings
  has_many :rp_snapshots

	enum race: [ :celt, :elf, :firbolg, :lurikeen, :sylvan, :dwarf, :kobold, :norseman, :troll, :valkyn, :briton, :saracen, :avalonian, :highlander, :inconnu ]
	enum daoc_class: [ :animist, :bard, :blademaster, :champion, :druid, :eldritch, :enchanter, :hero, :mentalist, :nightshade, :ranger, :valewalker, :warden, :naturalist, :stalker, :guardian, :magician, :forester, :berserker, :bonedancer, :healer, :hunter, :runemaster, :savage, :shadowblade, :shaman, :skald, :spiritmaster, :thane, :warrior, :viking, :seer, :mystic, :midgardrogue, :armsman, :cabalist, :cleric, :friar, :infiltrator, :mercenary, :minstrel, :necromancer, :paladin, :reaver, :scout, :sorcerer, :theurgist, :wizard, :fighter, :acolyte, :albionrogue, :mage, :elementalist, :disciple ]
	enum realm: [ :hibernia, :midgard, :albion, "7" ]
  
  self.create_player(name, guild_name, race, daoc_class, realm, level, realm_level, total_rps, last_update)
    new_player = nil
    if !Player.exists?(:name => name)
      player_guild = nil
      if Guild.exists?(:name => guild_name)
        player_guild = Guild.find_by(:name => guild_name)
      else
        player_guild = Guild.new(:name => guild_name, :realm => realm)
        player_guild.save
      end
      
      new_player = Player.new(:name => name, :guild => player_guild.id, :race => race, :daoc_class => daoc_class, :realm => realm, :realm_level => realm_level, :total_rps => total_rps, :last_api_update => last_update)
      new_player.save
    end
    
    return new_player
  end
end