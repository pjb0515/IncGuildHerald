class PlayerController < ApplicationController

  def player_details
    @player = Player.find_by(:name => params[:name])
  end
  
  def top_players
    @players = Player.order("total_rps").limit(5)
  end
end
