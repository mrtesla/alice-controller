$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require "bundler/capistrano"


set :alice_host, "machine-003.mrhenry.be"
set :alice_port, 4080
# set :alice_application, "alice.production"
set :bundle_without, [:development, :test, :deploy]

set :application, "alice"
set :repository,  "git://github.com/integrityio/alice.git"
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache

set :user, "root"

set :use_sudo, false
set :keep_releases, 4

set :deploy_to,   "/var/u"
set :current_dir, "apps/#{application}"
set :shared_dir,  "shared/#{application}"
set :version_dir, "releases/#{application}"

role :app, "machine-003.mrhenry.be"
role :web, "machine-003.mrhenry.be"
role :db,  "machine-003.mrhenry.be", :primary => true

namespace :deploy do
  [:restart, :start, :stop].each do |t|
    desc "#{t} task is a no-op with pluto"
    task t, :roles => :app do ; end
  end
end

task :set_shared_permissions do
  run <<-SH.gsub(/\s+/, ' ').strip
    chown -R pluto:pluto
      #{current_release}/tmp
      #{deploy_to}/#{shared_dir}/log
      #{deploy_to}/#{shared_dir}/pids
      #{deploy_to}/#{shared_dir}/system
  SH
end

task :overwrite_rvmrc do
  run <<-SH.gsub(/\s+/, ' ').strip
    echo "rvm #{rvm_ruby_string}" > #{current_release}/.rvmrc
  SH
end

after 'deploy:update_code' do
  run "cd #{release_path}; cp #{deploy_to}/#{shared_dir}/envrc ./.envrc"
end

after 'deploy:update_code' do
  run "cd #{release_path}; bundle exec rake db:migrate"
end

after "deploy", :overwrite_rvmrc
after "deploy", :set_shared_permissions
after "deploy", "deploy:cleanup"

if ENV['AIRBRAKE_KEY']
  require './config/boot'
  require 'airbrake/capistrano'
end
