Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get '/' => 'inc#index', as: :index_inc
  get '/herald' => 'herald#index', as: :index_herald
  
  get '/herald/player' => 'player#index', as: :index_player
  get '/herald/player/find' => 'player#search_players', as: :search_players
  get '/herald/player/find/:name' => 'player#player_details', as: :player_details
  get '/herald/player/top_rps' => 'player#top_players', as: :top_players
  
  get '/herald/guild' => 'guild#index', as: :index_guild
  get '/herald/guild/find' => 'guild#search_guilds', as: :search_guilds
  get '/herald/guild/find/:name' => 'guild#guild_details', as: :guild_details
  get '/herald/guild/top_rps' => 'guild#top_guilds', as: :top_guilds
  
end
