require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  # do not run integration tests, doesn't work on TravisCI
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

task :environment do
  ENV["RACK_ENV"] ||= 'development'
  require File.expand_path("../config/environment", __FILE__)
end

task routes: :environment do
  Opg::API.routes.each do |route|
    options = route.instance_values['options']
    puts [options[:method], options[:path], options[:description]].join("    ")
  end
end

namespace :db do
  namespace :mongoid do
    desc "Create the indexes defined on Lpa and Applicant models"
    task create_indexes: :environment do
      Applicant.create_indexes
      Lpa.create_indexes
      nil
    end
  end
end
