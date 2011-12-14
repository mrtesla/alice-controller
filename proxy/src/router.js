var Http = require('http')
,   Url  = require('url')
,   FS   = require('fs')
,   Router
,   Environment
;


exports.create = function(callback){
  return new Router(callback);
};


Router = function(callback){
  this._callback   = callback;

  this.agent  = new Http.Agent
  this.agent.maxSockets = 100;
  var agent = this.agent;

  this.server = Http.createServer();
  this.server.on('request', function(d_req, d_res){
    var options
    ,   url
    ,   env
    ,   u_req
    ;

    url = Url.format({
      'protocol' : 'http',
      'host'     : d_req.headers.host,
      'pathname' : d_req.url
    });


    d_req.pause();

    env = new Environment(agent, d_req, d_res);
    env.upstream_url = url;
    env.url     = Url.parse(url);
    env.headers = d_req.headers;
    env.method  = d_req.method;

    callback(env);
  });
};

Router.prototype.listen = function(port){
  this.server.listen(port);
};

Environment = function(agent, d_req, d_res){
  this.agent = agent;
  this.d_req = d_req;
  this.d_res = d_res;
};

Environment.prototype.respond = function(status) {
  var file
  ;

  file = "errors/"+status+".html";

  if (status == 'maintenance') {
    status = 503;
  }

  if (this.method == 'HEAD') {
    this.d_res.writeHead(status);
    return;
  }

  this.d_res.writeHead(status, {'Content-Type': 'text/html'});
  this.stream = FS.createReadStream(file);
  this.stream.pipe(this.d_res);
};

Environment.prototype.forward = function(host, port) {
  var options
  ,   u_req
  ,   env = this
  ;

  console.log('FWD: '+this.upstream_url);

  options = {
    'agent'   : this.agent,
    'host'    : host,
    'port'    : port,
    'method'  : this.method,
    'path'    : this.url.path,
    'headers' : this.headers
  };

  this.u_req = Http.request(options);
  this.u_req.setHeader('host', this.headers.host);

  this.u_req.setTimeout(30000, function(){
    env.respond(503);
  });

  this.u_req.on('response', function(u_res){
    env.d_res.writeHead(u_res.statusCode, u_res.headers);
    u_res.pipe(env.d_res);
    // handle trailers
  });

  this.u_req.on('error', function(){
    env.respond(503);
  });

  if (this.d_req.readable) {
    this.d_req.pipe(this.u_req);
    this.d_req.resume();
  } else {
    this.u_req.end();
  }
  // handle trailers
};

