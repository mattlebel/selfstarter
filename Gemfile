source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '3.2.13'
gem 'bootstrap-sass', '2.1'
gem 'devise'
gem 'pg'
gem "friendly_id", "~> 4.0.9"

gem 'paperclip', '~> 3.0'
gem 'ckeditor'
gem 'aws-sdk'

gem 'foreman'

group :development do
  gem 'pry-rails'
end

group :production do
  gem 'thin'
  gem 'newrelic_rpm'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "asset_sync"
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'shoulda'
end

# jQuery & jQuery UI
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'crowdtilt', github: 'msaint/crowdtilt'