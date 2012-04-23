source 'http://rubygems.org'

gem 'rails', '3.2.3'

gem 'formtastic', '~> 2.0.0'
gem 'formtastic-bootstrap', require: 'formtastic-bootstrap'
gem 'jquery-rails'
gem 'devise'

gem 'redis'
gem 'thin'
# gem 'fnordmetric', git: 'git://github.com/paulasmuth/fnordmetric.git'
# gem 'fnordmetric', git: 'git://github.com/fd/fnordmetric.git', ref: 'topics/middleware'
# gem 'fnordmetric', path: ENV['HOME'] + '/Projects/fnordmetric'
gem 'kaminari'
gem "airbrake"
gem "chef", require: false, git: 'git://github.com/opscode/chef.git', ref: '0.10.8'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
group :deploy do
  gem 'capistrano'
  # gem 'capistrano-alice', path: ENV['HOME'] + '/Projects/capistrano-alice'
  gem 'capistrano-alice', git: 'git://github.com/mrtesla/capistrano-alice.git'
end

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
  gem "therubyracer"
end
