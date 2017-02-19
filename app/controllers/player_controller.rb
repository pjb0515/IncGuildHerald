class PlayerController < ApplicationController

  def player_details
    @player = Player.find_by(:name => params[:name])
  end
end
