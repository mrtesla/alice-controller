var Router = require('./src/router')
,   Http   = require('http')
;

var router
;

router = Router.create('passer', function(env){

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

var port = process.argv[2] || process.env['PORT'] || '5200';
port = parseInt(port, 10);
router.listen(port);
console.log('listening on port '+port);

var _ping = function(){
  var body
  ,   req
  ;

  body = JSON.stringify([{'type': 'passer', 'machine': 'localhost', 'port': port}]);

  req = Http.request({
    host: 'localhost',
    port: 5000,
    path: '/api_v1/register.json',
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

setInterval(_ping, 600000); // every 10 minutes
setTimeout(_ping,   30000);

