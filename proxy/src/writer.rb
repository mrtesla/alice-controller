class Writer < Sinatra::Base

  post '/routers' do
    router = [params[:host], params[:port]].join(' ')
    id     = Digest::SHA1.hexdigest(router)

    r = redis.multi do
      redis.set   "routers:#{id}", router
      redis.lrem  'routers', 0, router
      redis.lpush 'routers', router
    end

    r ? "OK #{id}" : "FAIL"
  end

  delete '/routers/:id' do
    id     = params[:id]
    router = nil

    redis.watch "routers:#{id}"

    router = redis.get("routers:#{id}")

    r = redis.multi do
      redis.del  "routers:#{id}"
      redis.lrem "routers", 0, router
    end

    r ? "OK" : "FAIL"
  end

  post '/endpoints' do
    host     = params[:host]
    port     = params[:port]
    endpoint = [params[:host], params[:port]].join(' ')
    id       = Digest::SHA1.hexdigest(endpoint)

    r = redis.multi do
      redis.set     "endpoints:#{id}",   endpoint
      redis.lrem    "endpoints:#{host}", 0, port
      redis.lpush   "endpoints:#{host}", port
      redis.zincrby "machines", 1, host
    end

    r ? "OK: #{id}" : "FAIL"
  end

  delete '/endpoints/:id' do
    id       = params[:id]
    host     = nil
    port     = nil
    endpoint = nil

    redis.watch("endpoints:#{id}")

    endpoint = redis.get("endpoints:#{id}")
    host, port = endpoint.split(' ')

    r = redis.multi do
      redis.del "endpoints:#{id}"
      redis.lrem "endpoints:#{host}", 0, port
      redis.zincrby "machines", -1, host
      redis.zremrangebyscore "machines", '-inf', '0)'
    end

    r ? "OK" : "FAIL"
  end

  post '/backends' do
    machine     = params[:machine]
    application = params[:application]
    process     = params[:process]
    port        = params[:port]
    backend     = [machine, application, process, port].join(' ')
    id          = Digest::SHA1.hexdigest(backend)

    r = redis.multi do
      redis.set     "backends:#{id}", backend
      redis.lrem    "applications:#{application}:backends:#{process}", 0, backend
      redis.lpush   "applications:#{application}:backends:#{process}", backend
      redis.zincrby "applications:#{application}:backends", 1, process
      redis.zincrby "applications", 1, application
    end

    r ? "OK: #{id}" : "FAIL"
  end

  delete '/backends/:id' do
    id          = params[:id]
    machine     = nil
    application = nil
    process     = nil
    port        = nil
    backend     = nil

    redis.watch "backends:#{id}"

    backend = redis.get("backends:#{id}")
    machine, application, process, port = backend.split(' ')

    r = redis.multi do
      redis.del     "backends:#{id}"
      redis.lrem    "applications:#{application}:backends:#{process}", 0, backend
      redis.zincrby "applications:#{application}:backends", -1, process
      redis.zincrby "applications", -1, application
      redis.zremrangebyscore "applications:#{application}:backends", '-inf', '0)'
      redis.zremrangebyscore "applications", '-inf', '0)'
    end

    r ? "OK" : "FAIL"
  end

  post '/domains' do
    domain  = params[:domain]
    actions = params[:actions]
    id      = Digest::SHA1.hexdigest(domain)

    r = redis.multi do
      redis.set  "domains:#{id}", domain
      redis.hset "domains", domain, actions
    end

    r ? "OK: #{id}" : "FAIL"
  end

  delete '/domains/:id' do
    id     = params[:id]
    domain = nil

    redis.watch "domains:#{id}"

    domain = redis.get("domains:#{id}")

    r = redis.multi do
      redis.del  "domains:#{id}"
      redis.hdel "domains", domain
    end

    r ? "OK" : "FAIL"
  end

  post '/paths' do
    application = params[:application]
    path        = params[:path]
    actions     = params[:actions]
    key         = [application, path].join(' ')
    id          = Digest::SHA1.hexdigest(key)

    r = redis.multi do
      redis.set  "paths:#{id}", key
      redis.hset "paths", key, actions
    end

    r ? "OK: #{id}" : "FAIL"
  end

  delete '/paths/:id' do
    id  = params[:id]
    key = nil

    redis.watch "paths:#{id}"

    key = redis.get("paths:#{id}")

    r = redis.multi do
      redis.del  "paths:#{id}"
      redis.hdel "paths", key
    end

    r ? "OK" : "FAIL"
  end

private

  def redis
    @redis = Redis.new
  end

end
