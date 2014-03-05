source "https://rubygems.org"
ruby "2.1.0"
Bundler.require(:default, :production)
gem 'sinatra'
gem 'thin'
gem 'twilio-ruby'
gem 'data_mapper'
gem 'rspec'
gem 'capybara'

group :development do
gem 'dm-sqlite-adapter'
end

group :production do
gem 'dm-postgres-adapter'
end
