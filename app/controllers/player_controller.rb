class PlayerController < ApplicationController

  def search_players
    @search_name = params[:name]
    @players = Player.having("name like ?", "#{@search_name}%")
  end
  
  def player_details
    @player = Player.find_by(:name => params[:name])
  end
  
  def top_players
    @realm = params[:realm]
    @duration = params[:duration]
    
    if @realm.blank? or @duration.blank?
      @players = Player.order("total_rps DESC").limit(25)
    else
      @players = Player.get_top_players(@realm, @duration)
      
      respond_to :json
    end
  end
end
