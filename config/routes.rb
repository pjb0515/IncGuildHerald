Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get '/herald' => 'herald#index', as: :index_herald
  get '/herald/player' => 'player#index', as: :index_player
  get '/herald/player/find' => 'player#player_details', as: :player_details
  get '/herald/player/top_rps' => 'player#top_players', as: :top_players
  get '/herald/guild' => 'guild#index', as: :index_guild
  get '/herald/guild/find' => 'guild#guild_details', as: :guild_details
  get '/herald/guild/top_rps' => 'guild#top_guilds', as: :top_guilds
  
  root 'herald#index'
end
