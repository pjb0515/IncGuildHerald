Rails.application.routes.draw do
  get '/herald' => 'herald#index', as: :index_herald
  get '/herald/player' => 'player#index', as: :index_player
  get '/herald/player/find/:name' => 'player#player_details', as: :player_details
  get '/herald/player/top_rps/:ranking_type' => 'player#top_players', as: :top_players
  get '/herald/guild' => 'guild#index', as: :index_guild
  get '/herald/guild/find/:name' => 'guild#guild_details', as: :guild_details
end
