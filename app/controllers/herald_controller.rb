class HeraldController < ApplicationController
  require 'net/http'
  require 'net/https'

  def index
  end
  
  def get_dump
    Spawnling.new do
      url = URI.parse('https://uthgard.org/herald/api/dump')
      
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = true

      headers = {}

      res = http.post(url, "", headers)
      
      puts res.body
    end
  end
  
  # NOT IN USE YET
  def post_dump
	if params[:password].eql? ENV["DUMP_PASSWORD"]
	  url = URI.parse('https://uthgard.org/herald/api/dump')
	
	  http = Net::HTTP.new(url.host, 443)
	  http.use_ssl = true

	  headers = {}

	  res = http.post(url, "", headers)
	  
	  dump_hash = JSON.parse res.body
	  
	  
	  dump_hash.each do |key, value|
		name = value["Name"]
		guild = value["Guild"]
		race = value["Race"]
		daoc_class = value["Class"]
		realm = value["Realm"]
		last_update = value["LastUpdate"]
		
		new_player = Player.new(:name => name, :guild => guild, :race => race, :daoc_class => daoc_class, :realm => realm)
		puts new_player.name
		puts new_player.race
		puts new_player.realm
		puts new_player.daoc_class
	  end
	end
  
	redirect_to action: :index
  end
end
