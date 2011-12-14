var Express = require('express')
,   Dnode   = require('dnode')
;

var Endpoints
;

var app
,   d
;

app = Express.createServer();
app.use(Express.logger());
app.use(Express.static(__dirname + '/../public'));

app.configure(function(){
  app.set('views', __dirname + '/../views');
});

app.get('/', function(req, res){
});

port = parseInt(process.argv[2] || '8001', 10);
app.listen(port);

console.log('listening at port: '+port);
