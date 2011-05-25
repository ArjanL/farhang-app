# encoding: UTF-8
#
# Farhang-app
#
# Author:: burningTyger (https://github.com/burningTyger)
# Home:: https://github.com/burningTyger/farhang-app
# Copyright:: Copyright (c) 2011 burningTyger
# License:: MIT License
#
require 'sinatra'
require 'haml'
require 'sass'
require 'mongo_mapper'
require 'sinatra/reloader' if development?

configure do
  if ENV['MONGOLAB_URL']
    MongoMapper.database = ENV['MONGOLAB_DATABASE']
    MongoMapper.connection = Mongo::Connection.new(ENV['MONGOLAB_URL'], 27107)
    MongoMapper.database.authenticate(ENV['MONGOLAB_USER'], ENV['MONGOLAB_PASS'])
  else
    MongoMapper.connection = Mongo::Connection.new('localhost')
    MongoMapper.database = "testing"
  end
end

FARHANG_VERSION = "0.1"

class Entry
  include MongoMapper::Document
  key :term, String
  key :trans, Hash
  timestamps!
end

not_found do
  'page not found'
end

error do
  'error'
end

#sass style sheet generation
get '/css/:file.css' do
  halt 404 unless File.exist?("views/#{params[:file]}.scss")
  time = File.stat("views/#{params[:file]}.scss").ctime
  last_modified(time)
  scss params[:file].intern
end

get '/' do
  unless params[:search].nil? or params[:search].empty?
    entries = Entry.all(:term => Regexp.new(/#{params[:search]}/i))
  end
  haml :home, :locals => { :entries => entries }
end
