class GuildController < ApplicationController

  def search_players
    @search_name = params[:name]
    @guilds = Guild.where("name like ?", "#{@search_name}%")
  end
  
  def guild_details
    @guild = Guild.find_by(:name => params[:name])
  end
  
  def top_guilds
    @realm = params[:realm]
    @duration = params[:duration]
    
    if @realm.blank? or @duration.blank?
      @guilds = Guild.order("total_rps DESC").limit(25)
    else
      @guilds = Guild.get_top_guilds(@realm, @duration)
      
      respond_to :json
    end
  end
end
