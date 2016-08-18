require 'pry'
require 'json'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'sinatra/reloader'

class Application<Sinatra::Base

  get '/api/v1/trains' do
    train_data = get_train_data(params['long'])
    if params['long'] != "true" #deletes the detailed info if you didnt ask for it. 
      train_data.each { |h| h.delete(:detail) } 
    end
    train_data.to_json #response
  end

  get '/api/v1/trains/:id' do
    train_data = get_train_data(params['long'])
    train_to_get = params['id'].upcase
    train_data = train_data.find { |x| x[:train] == train_to_get } #looks for single, deletes the rest
    if params['long'] != "true" #deletes the detailed info if you didnt ask for it. 
      train_data.delete(:detail)
    end
    train_data.to_json #response
  end

  def get_train_data(long) #this gets the train data and puts it into a simple, usable hash. 
    group_count = 10 #this is how many train groups the xml file has. i.e. ABC is one group.
    
    data = Nokogiri::XML(open('http://web.mta.info/status/serviceStatus.txt')) #opens god-awful xml file.
    trains = data.xpath('//subway').xpath('//name').first(group_count) #gets X train names from xml
    trains.map! do |train| train = train.text.to_s end #reduces nokogiri object to simple array. 
    status = data.xpath('//subway').xpath('//status').first(group_count) #get X status for trains from xml
    status.map! do |train| train = train.text.to_s end #reduces nokogiri object to simple array. 
    long_status = data.xpath('//subway').xpath('//text').first(group_count) #get X status for trains from xml
    if long_status != nil #this is a check to see if the xml file had long stats
      long_status.map! do |train| train = train.text.to_s end #reduces nokogiri object to simple array. 
    end

    buildResponse(trains,status,long_status) #build the response
    
    @final_hash #return hash 
  end

  def buildResponse(trains,status,long_status) #builds the reponse object. needs to be DRYer
    @final_hash = [] #blank hash for final ouput
    work_hashing = trains.zip(status,long_status) #zips the arrays together.
    work_hashing.each do |train,status,long_status| #split multiple trains to individual. ACE > A,C,E
      train.length.times do |i|
        single_train = {train:train[i],status:status,detail:long_status} #each train is a hash
        @final_hash.push(single_train) #after split, push to new array. 
      end
    end
  end
end
