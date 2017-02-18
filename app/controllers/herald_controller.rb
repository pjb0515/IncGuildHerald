class HeraldController < ApplicationController
  require 'net/http'
  require 'net/https'

  def index
  end
  
  def get_dump
    url = URI.parse('http://uthgard.org/herald/api/dump')
    
    http = Net::HTTP.new(url.host, 443)
    http.use_ssl = true

    headers = {}

    res = http.post(url, "", headers)
    
    dump_hash = JSON.parse res.body
    
    
    dump_hash.each do |key, value|
      puts value["Name"]
      puts value["Guild"]
      puts "---------------------"
    end
  end
  
  # NOT IN USE YET
  def post_dump
    if params[:password].eql? ENV["DUMP_PASSWORD"]
      url = URI.parse('https://uthgard.org/herald/api/dump')
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      dump_hash = JSON.parse res.body
      
      dump_hash.each do |key, value|
        puts value[:Name]
        puts value[:Guild]
        puts "---------------------"
      end
    end
  
    redirect_to action: :index
  end
end
