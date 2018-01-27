desc "This task is called by the Heroku scheduler add-on to process the Uthgard dump api"
task :process_dump => :environment do
  puts "Updating characters..."
  
  url = URI.parse('https://www2.uthgard.net/herald/api/dump')
      
  http = Net::HTTP.new(url.host, 443)
  http.use_ssl = true

  headers = {}

  res = http.post(url, "", headers)
  
  single_player_splits = res.body.split(/"[a-z]+": {/)
  
  split_length = single_player_splits.length-1
  
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
  puts "done."
  
  # Destroy all players who haven't been updated in 7 days. This means the character has been deleted from the server.
  total_pages = Player.where("updated_at < ?", 7.days.ago).page(1).total_pages
  for i in 1..total_pages
    Player.where("updated_at < ?", 7.days.ago).page(i).destroy_all
  end
  
  # Destroy all RP snapshots older than 30 days, excluding 1 per month.
  total_pages = Player.where("level < ?", 44).page(1).total_pages
  for i in 1..total_pages
    Player.where("level < ?", 44).page(i).each do |player|
      month = nil
      snapshots_to_destroy = []
      player.rp_snapshots.where("snapshot_date < ?", 30.days.ago).order("snapshot_date ASC").each do |player_rp_snapshot|
        current_snapshot_month = player_rp_snapshot.snapshot_date.strftime("%B")
        
        if current_snapshot_month != month
          month = current_snapshot_month
        else
          snapshots_to_destroy << player_rp_snapshot
        end
      end
      snapshots_to_destroy.each(&:destroy)
    end
  end
  
  
  puts "Updating guilds..."
  
  total_pages = Guild.page(1).total_pages
  for i in 1..total_pages
    Guild.page(i).each do |guild|
      guild.temp_calculate_full_rps_gained
    end
  end
  puts "done."
end

task :update_guilds => :environment do
  puts "Updating guilds..."
  
  total_pages = Guild.page(1).total_pages
  for i in 1..total_pages
    Guild.page(i).each do |guild|
      guild.temp_calculate_full_rps_gained
    end
  end
  puts "done."
end