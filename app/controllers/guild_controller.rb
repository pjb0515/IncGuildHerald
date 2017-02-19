class GuildController < ApplicationController

  def guild_details
    @guild = Guild.find_by(:name => params[:name])
  end
end
