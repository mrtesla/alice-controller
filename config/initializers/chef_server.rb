require 'alice/chef'

Chef::Config[:chef_server_url] = ENV['CHEF_SERVER']
Chef::Config[:search_url]      = ENV['CHEF_SERVER']
Chef::Config[:node_name]       = ENV['CHEF_CLIENT']
Chef::Config[:client_key]      = ENV['CHEF_CLIENT_KEY']

begin
  data_bag = Chef::DataBag.new
  data_bag.name("alice-processes")
  data_bag.save
rescue Net::HTTPServerException
end
