$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

puts "==== env: #{ENV['RACK_ENV']}"

Bundler.require :default, ENV['RACK_ENV']

Mongoid.load!( File.dirname(__FILE__) + "/../config/mongoid.yml")

Dir[File.expand_path('../../api/*.rb', __FILE__)].each do |f|
  require f
end

require 'api'
require 'lpa_app'

