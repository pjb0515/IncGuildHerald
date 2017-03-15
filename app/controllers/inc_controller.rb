class IncController < ApplicationController

  def index
    @inc_members = Player.where(guild: Guild.find_by(name: "INC"), level: 49..50).order("total_rps DESC")
  end
end
