class HeraldController < ApplicationController
  require 'net/http'
  require 'net/https'

  def index
  end
  
  def update_guilds_dump
    Spawnling.new do
      Guild.update_guilds
    end
  end
  
  def get_dump
    Spawnling.new do
      url = URI.parse('https://uthgard.org/herald/api/dump')
      
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = true

      headers = {}

      res = http.post(url, "", headers)
      
      single_player_splits = res.body.split(/"[a-z]+": {/)
      
      split_length = single_player_splits.length
      
      for i in 1..split_length
      
        single_player_json = single_player_splits[i]
        single_player_json = single_player_json.gsub(/},/, "}")
        single_player_json = "{ " + single_player_json
        
        #If last item, remove double close brace.
        if i == split_length
          single_player_json = single_player_json.gsub(/}\s+}/, "}")
        end
        
        player_hash = JSON.parse single_player_json
        
        name = player_hash["Name"]
        guild_name = player_hash["Guild"]
        race = player_hash["Race"].downcase
        daoc_class = player_hash["Class"].downcase
        realm = player_hash["Realm"].downcase
        last_update = player_hash["LastUpdated"]
        level = player_hash["Level"]
        realm_level = player_hash["RealmRank"]
        total_rps = player_hash["Rp"]
        
        Player.update_player(name, guild_name, race, daoc_class, realm, level, realm_level, total_rps, last_update)
        
      end
      
      Guild.update_guilds
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
