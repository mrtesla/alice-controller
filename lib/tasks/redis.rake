namespace :db do

  desc "Rebuild the Redis database from the MySQL database"
  task "redis:rebuild" => :environment do
    REDIS.keys('alice.http|*').each do |key|
      REDIS.del(key)
    end

    Core::Application.send_to_redis
    Http::Router.send_to_redis
    Http::Passer.send_to_redis
    Http::Backend.send_to_redis
    Http::DomainRule.send_to_redis
  end

end
