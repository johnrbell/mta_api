require 'pry'
require 'json'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'sinatra/reloader'

class Application<Sinatra::Base
  get '/api' do
    if params['q']
      train_to_get = params['q'].upcase
      response = get_train_data(params['long'].downcase)
      response.find { |x| x[:train] == train_to_get }.to_json
    else
      get_train_data(params['long']).to_json
    end
  end

  def get_train_data(long) #this gets the train data and puts it into a simple, usable hash. 
    group_count = 10 #this is how many train groups the xml file has. i.e. ABC is one group.
    @final_hash = [] #blank hash for final ouput

    data = Nokogiri::XML(open('http://web.mta.info/status/serviceStatus.txt')) #opens xml file.
    trains = data.xpath('//subway').xpath('//name').first(group_count) #gets X train names from xml
    status = data.xpath('//subway').xpath('//status').first(group_count) #get X status for trains from xml
    long_status = data.xpath('//subway').xpath('//text').first(group_count) #get X status for trains from xml
    trains.map! do |train| train = train.text.to_s end #reduces to simple array. 
    status.map! do |train| train = train.text.to_s end #reduces to simple array. 
    long_status.map! do |train| train = train.text.to_s end #reduces to simple array. 
    
    if long == 'true'
      buildResponse(trains,status,long_status)
    else
      buildResponse(trains,status,nil)
    end

    @final_hash #returns the hash. 
  end

  def buildResponse(trains,status,long_status) #builds the reponse object. needs to be DRYer
    if long_status
      work_hashing = trains.zip(status,long_status) #zips the arrays together.
      work_hashing.each do |train,status,long_status| #split multiple trains to individual. ACE > A,C,E
        train.length.times do |i|
          single_train = {train:train[i],status:status,detail:long_status.to_s} #each train is a hash
          @final_hash.push(single_train) #after split, push to new array. 
        end
      end
    else
      work_hashing = trains.zip(status) #zips the arrays together.
      work_hashing.each do |train,status| #split multiple trains to individual. ACE > A,C,E
        train.length.times do |i|
          single_train = {train:train[i],status:status} #each train is a hash
          @final_hash.push(single_train) #after split, push to new array. 
        end
      end
    end
  end



end
