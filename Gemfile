source 'http://rubygems.org'

gem 'rails', '3.1.1'
gem 'formtastic-bootstrap'
gem 'jquery-rails'

gem 'redis'
gem 'thin'
gem 'fnordmetric', git:  'git://github.com/fd/fnordmetric.git'
# gem 'fnordmetric', path: ENV['HOME'] + '/Projects/fnordmetric'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :test, :development do
  gem "rspec-rails"
  gem 'shoulda-matchers'
  gem 'sqlite3'
end

group :staging, :development do
  gem 'mysql2'
end
