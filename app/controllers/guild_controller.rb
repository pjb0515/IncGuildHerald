class GuildController < ApplicationController

  def search_guilds
    @search_name = params[:name]
    
    if @search_name.blank?
      @guilds = nil
    else
      @guilds = Guild.where("lower(name) like ?", "%#{@search_name.downcase}%")
    end
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
