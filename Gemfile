source 'https://rubygems.org'
source 'http://gems.github.com'

ruby '2.0.0'

gem 'rack'

gem 'mongoid', '~> 4.0.0', github: 'mongoid/mongoid', ref: 'df4580b'

gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'json'

gem 'validates_timeliness'

gem 'foreman'

group :development, :test do
  gem 'rerun'
  gem 'rspec'
  gem 'pry-byebug'
end

group :development do
  gem 'rake'
end

group :test do
  gem 'rack-test'
  gem 'guard-rspec'
  gem 'database_cleaner'
  gem 'coveralls', require: false
end

