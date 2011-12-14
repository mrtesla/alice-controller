var Router = require('./src/router')
,   Redis  = require('redis')
;

var router
,   redis
;

var _lookup_app_for_hostname
,   _check_for_maintenance_mode
,   _select_backend_for_app
,   _select_end_point_for_machine
;

_lookup_app_for_hostname = function(env){
  var hostname
  ;

  hostname = env.url.hostname;

  if (hostname.indexOf('www.') === 0) {
    hostname = hostname.substr(4);
  }

  redis.get('hosts:'+hostname+':app', function(err, app){

    if (err) {
      console.error('Redis error: '+err);
      // return 500
      env.respond(500);
      return;
    }

    if (!app) {
      // return 404
      env.respond(404);
      return;
    }

    env.app = app;
    _check_for_maintenance_mode(env);
  });
};

_check_for_maintenance_mode = function(env){
  redis.get('apps:'+env.app+':maintenance', function(err, maintenance){

    if (err) {
      console.error('Redis error: '+err);
      // return 500
      env.respond(500);
      return;
    }

    if (maintenance == 'true') {
      // return 503 (maintenance)
      env.respond('maintenance');
      return;
    }

    _select_backend_for_app(env);
  });
};

_select_backend_for_app = function(env){
  redis.brpoplpush('apps:'+env.app+':backends-list',
                   'apps:'+env.app+':backends-list',
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

    backend = backend.split(';');
    env.machine = backend[0];
    env.port    = backend[1];

    _select_end_point_for_machine(env);
  });
};

_select_end_point_for_machine = function(env){
  redis.brpoplpush('machines:'+env.machine+':endpoints-list',
                   'machines:'+env.machine+':endpoints-list',
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

    endpoint = endpoint.split(';');

    env.headers['X-Pluto-Backend-Port'] = env.port;
    env.forward(endpoint[0], parseInt(endpoint[1], 10));
  });
};

redis = Redis.createClient();
router = Router.create(_lookup_app_for_hostname);
router.listen(process.env['PORT']);

/*
 * http://mrhenry.be/javascripts/*             => fs
 * http://mrhenry.be/stylesheets/*             => fs
 * http://mrhenry.be/images/*                  => fs
 * http://mrhenry.be/favicon.ico               => fs
 * http://mrhenry.be/system/*                  => fs
 * http://mrhenry.be/blog/wp-content/uploads/* => fs
 * http://mrhenry.be/blog/*                    => php
 * http://mrhenry.be/*                         => rails
 */
