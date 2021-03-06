class PlayerController < ApplicationController

  def search_players
    @search_name = params[:name]
    
    if @search_name.blank?
      @players = nil
    else
      @players = Player.where("lower(name) like ?", "#{@search_name.downcase}%")
    end
  end
  
  def player_details
    @player = Player.find_by(:name => params[:name])
  end
  
  def top_players
    @realm = params[:realm]
    @duration = params[:duration]
    @daoc_class = params[:daoc_class]
    
    if @realm.blank? or @duration.blank?
      @players = Player.order("total_rps DESC").limit(25)
    else
      @players = Player.get_top_players(@realm, @duration, @daoc_class)
      
      respond_to :json
    end
  end
end
