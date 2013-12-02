source 'https://rubygems.org'

ruby '2.0.0'

gem 'rack'
gem 'thin'

gem 'mongoid', '~> 4.0.0', github: 'mongoid/mongoid', ref: 'df4580b'

gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'json'

gem 'validates_timeliness'

gem 'foreman'

gem 'rack_moj_auth', github: 'ministryofjustice/x-moj-auth', branch: 'use_X_USER_ID_header_to_authenticate'

group :development, :test do
  gem 'rerun'
  gem 'rspec'
  gem 'pry-byebug'
  gem 'clogger' # Rack middleware for logging HTTP requests
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

