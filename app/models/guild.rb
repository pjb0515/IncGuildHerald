class Guild < ActiveRecord::Base
  has_many :players
  
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
end
