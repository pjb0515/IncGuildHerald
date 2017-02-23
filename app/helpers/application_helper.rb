module ApplicationHelper
  def active_herald_index
    "class=active" if controller_name == "herald" && action_name == "index"
  end
  
  def active_top_players
    "class=active" if controller_name == "player" && action_name == "top_players"
  end
  
  def active_top_guilds
    "class=active" if controller_name == "guild" && action_name == "top_guilds"
  end
  
  
end
