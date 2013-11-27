$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

puts "==== RACK_ENV: #{ENV['RACK_ENV']}"

Bundler.require :default, ENV['RACK_ENV']

require 'rack_moj_auth'
require 'mongoid'

Mongoid.load!( File.dirname(__FILE__) + "/../config/mongoid.yml")

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular("person_to_be_told", "people_to_be_told")
end

# TODO: Rather nasty as requiring them in alphabetical order doesn't work properly.
require File.expand_path('app/models/address.rb')
require File.expand_path('app/models/person_to_be_told.rb')
['app/models', 'api'].each do |dir|
  Dir[File.expand_path("../../#{dir}/*.rb", __FILE__)].sort.each do |f|
    require f
  end
end

require 'api'
require 'lpa_app'