Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get '/herald' => 'herald#index', as: :index_herald
  get '/herald/player' => 'player#index', as: :index_player
  get '/herald/player/find' => 'player#player_details', as: :player_details
  get '/herald/player/top_rps/:ranking_type' => 'player#top_players', as: :top_players
  get '/herald/guild' => 'guild#index', as: :index_guild
  get '/herald/guild/find' => 'guild#guild_details', as: :guild_details
  
  get '/herald/dump' => 'herald#get_dump', as: :herald_get_dump
  post '/herald/dump' => 'herald#post_dump', as: :herald_post_dump
  
  root 'herald#index'
end
