var Router = require('./src/router')
,   Redis  = require('redis')
,   Http   = require('http')
;

var router
,   redis
;

var _route_domain
,   _route_path
,   _select_backend_for_app
,   _select_passer_for_machine
;

_route_domain = function(env){
  var hostname
  ,   parts
  ,   lookup_hostnames
  ;

  hostname = env.url.hostname;
  parts = hostname.split('.');
  if (parts[parts.length - 1] === '') { parts.pop(); }

  lookup_hostnames = [parts.join('.')+'.'];
  while (parts.length > 0) {
    lookup_hostnames.push('*.' + parts.join('.') + '.');
    parts.shift();
  }

  lookup_hostnames.push('*.');

  redis.hmget('alice.http|domains', lookup_hostnames, function(err, rules){
    var actions
    ,   i
    ;

    if (err) {
      console.error('Redis error: '+err);
      // return 500
      env.respond(500);
      return;
    }

    for (i in rules) {
      if (rules[i]) {
        actions = JSON.parse(rules[i]);
        break;
      }
    }

    if (!actions) {
      // return 404
      env.respond(404);
      return;
    }

    actions.forEach(function(action){
      switch(action[0]){
      case 'forward':
        env.app = action[1];
        break;
      }
    });

    if (!env.app) {
      // return 404
      env.respond(404);
      return;
    }

    _route_path(env);
  });
};

_route_path = function(env){
  var parts
  ,   lookup_paths
  ;

  parts = env.url.path.split('/');
  if (parts[parts.length - 1] === '') { parts.pop(); }
  if (parts.length === 0) { parts.push(''); }

  lookup_paths = [env.url.path];
  while (parts.length > 0) {
    lookup_paths.push(parts.join('/') + '/*');
    parts.pop();
  }

  redis.hmget('alice.http|paths:'+env.app, lookup_paths, function(err, rules){
    var actions
    ,   i
    ;

    if (err) {
      console.error('Redis error: '+err);
      // return 500
      env.respond(500);
      return;
    }

    for (i in rules) {
      if (rules[i]) {
        actions = JSON.parse(rules[i]);
        break;
      }
    }

    if (!actions) {
      // return 404
      env.respond(404);
      return;
    }

    actions.forEach(function(action){
      switch(action[0]){
      case 'forward':
        env.process = action[1];
        break;
      }
    });

    if (!env.process) {
      // return 404
      env.respond(404);
      return;
    }

    _select_backend_for_app(env);
  });
};

_select_backend_for_app = function(env){
  redis.brpoplpush('alice.http|backends:'+env.app+':'+env.process,
                   'alice.http|backends:'+env.app+':'+env.process,
                   5,
                   function(err, backend){

    if (err) {
      console.error('Redis error: '+err);
      // return 500
      env.respond(500);
      return;
    }

    if (!backend) {
      // return 503
      env.respond(503);
      return;
    }

    backend = backend.split(' ');
    env.machine = backend[0];
    env.port    = backend[1];

    _select_passer_for_machine(env);
  });
};

_select_passer_for_machine = function(env){
  redis.brpoplpush('alice.http|passers:'+env.machine,
                   'alice.http|passers:'+env.machine,
                   5,
                   function(err, endpoint){

    if (err) {
      console.error('Redis error: '+err);
      // return 500
      env.respond(500);
      return;
    }

    if (!endpoint) {
      env.respond(503);
      return;
    }

    env.headers['X-Pluto-Backend-Port'] = env.port;
    env.forward(env.machine, parseInt(endpoint, 10));
  });
};



redis = Redis.createClient();
router = Router.create(_route_domain);

var port = process.argv[2] || process.env['PORT'] || '5200';
port = parseInt(port, 10);
router.listen(port);
console.log('listening on port '+port);

var _ping = function(){
  var body
  ,   req
  ;

  body = JSON.stringify({'host': 'localhost', 'port': port});

  req = Http.request({
    host: 'localhost',
    port: 5000,
    path: '/_ping/router.json',
    method: 'POST',
    headers: {
      'Content-Type':   'application/json',
      'Accepts':        'application/json',
      'Content-Length': body.length
    }
  }, function(res){
  });

  req.on('error', function(){
    console.log('Failed to ping!');
  });

  req.write(body);
  req.end();
};

setInterval(_ping, 60000);
_ping();
