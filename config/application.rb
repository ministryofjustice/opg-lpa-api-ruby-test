$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

puts "==== env: #{ENV['RACK_ENV']}"

Bundler.require :default, ENV['RACK_ENV']

Mongoid.load!( File.dirname(__FILE__) + "/../config/mongoid.yml")

['app/models', 'api'].each do |dir|
  Dir[File.expand_path("../../#{dir}/*.rb", __FILE__)].each do |f|
    puts "require #{f}"
    require f
  end
end

require 'api'
require 'lpa_app'

