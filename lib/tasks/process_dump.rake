desc "This task is called by the Heroku scheduler add-on to process the Uthgard dump api"
task :process_dump => :environment do
  puts "Updating characters..."
  
  url = URI.parse('https://www2.uthgard.net/herald/api/dump')
      
  http = Net::HTTP.new(url.host, 443)
  http.use_ssl = true

  headers = {}

  res = http.post(url, "", headers)
  
  single_player_splits = res.body.split(/"[a-z]+": {/)
  
  split_length = single_player_splits.length
   puts single_player_splits.last
  puts "done."
end
