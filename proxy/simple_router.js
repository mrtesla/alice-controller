var Router = require('./src/router')
;

var router
;

router = Router.create(function(env){
  // env.respond('maintenance');
  env.forward('127.0.0.2', 8080);
  // setTimeout(function(){
  //   env.forward('vpr8.prodius.be', 80);
  // }, 500);
});

router.listen(process.env['PORT']);

