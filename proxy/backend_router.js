var Router = require('./src/router')
;

var router
;

router = Router.create(function(env){

  var backend
  ;

  backend = env.headers['x-pluto-backend-port'];
  delete env.headers['x-pluto-backend-port'];
  if (!backend) {
    // return 503
    env.respond(503);
    return;
  }

  env.forward('127.0.0.1', parseInt(backend, 10));
});

router.listen(process.env['PORT']);

