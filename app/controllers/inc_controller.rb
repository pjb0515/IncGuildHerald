class IncController < ApplicationController

  def index
    @inc_members = Player.where(guild: Guild.find_by(name: "INC")).order(:total_rps)
  end
end
