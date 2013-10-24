source 'https://rubygems.org'
source 'http://gems.github.com'

ruby '2.0.0'

gem 'mongoid', '~> 4.0.0', github: 'mongoid/mongoid'

gem 'rack'
gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'json'

group :development, :test do
  gem 'rerun'
  gem 'rspec'
  gem 'pry-byebug'
  gem 'activeresource', '~> 4.0.0'
  gem 'remi-rackbox'
  gem 'active_racksource', github: 'robmckinnon/active_racksource'
end

group :development do
  gem 'rake'
end

group :test do
  gem 'rack-test'
  gem 'guard-rspec'
  gem 'capybara'
  gem 'database_cleaner'
end

