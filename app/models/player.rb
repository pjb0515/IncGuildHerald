class Player < ActiveRecord::Base
  belongs_to :guild
  has_many :player_rankings
  has_many :rp_snapshots

	enum race: [ :celt, :elf, :firbolg, :lurikeen, :sylvan, :dwarf, :kobold, :norseman, :troll, :valkyn, :briton, :saracen, :avalonian, :highlander, :inconnu ]
	enum daoc_class: [ :animist, :bard, :blademaster, :champion, :druid, :eldritch, :enchanter, :hero, :mentalist, :nightshade, :ranger, :valewalker, :warden, :naturalist, :stalker, :guardian, :magician, :forester, :berserker, :bonedancer, :healer, :hunter, :runemaster, :savage, :shadowblade, :shaman, :skald, :spiritmaster, :thane, :warrior, :viking, :seer, :mystic, :midgardrogue, :armsman, :cabalist, :cleric, :friar, :infiltrator, :mercenary, :minstrel, :necromancer, :paladin, :reaver, :scout, :sorcerer, :theurgist, :wizard, :fighter, :acolyte, :albionrogue, :mage, :elementalist, :disciple ]
	enum realm: [ :hibernia, :midgard, :albion, "7" ]
end
