load 'deploy' if respond_to?(:namespace) # cap2 differentiator

# Uncomment if you are using Rails' asset pipeline
load 'deploy/assets'

# Load bundled extentions
begin
  original_instance, self.class.instance = self.class.instance, self
  require 'bundler'
  Bundler.require(:deploy)
ensure
  self.class.instance = original_instance
end

Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks
