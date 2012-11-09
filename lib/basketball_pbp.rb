require 'treetop'
require 'mharris_ext'
require 'andand'
require 'mongo'
require 'mongoid'
require 'csv'

module BasketballPbp
  
end

BP = BasketballPbp

Mongoid.load!("config/mongoid.yml", :development)

%w(pbp_file event grammar).each do |f|
  load File.dirname(__FILE__) + "/basketball_pbp/#{f}.rb"
end

