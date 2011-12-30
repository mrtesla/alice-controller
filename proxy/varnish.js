var Handlebars = require('handlebars')
,   Http       = require('http')
,   Fs         = require('fs')
;


var _fetch_endpoints
,   _render_config
,   _update_config
,   _reload_varnish
;


var vcl_template
;


_fetch_endpoints = function(){
  var buffer
  ,   options
  ,   endpoints
  ,   report
  ;

  buffer = "";
  options = {
    host: 'localhost',
    port: 5000,
    path: '/api_v1/routers.json'
  };

  Http.get(options, function(res) {
    if (res.statusCode == 200) {
      res.setEncoding('utf8');
      res.on('data', function(chunk){
        buffer += chunk;
      });

      res.on('end', function(){
        endpoints = JSON.parse(buffer);
        _render_config(endpoints);
      });

      res.on('close', function(e){
        console.log("Got error: " + e.message);
      });
    } else {
      console.log("Got error: " + res.statusCode);
    }
  }).on('error', function(e) {
    console.log("Got error: " + e.message);
  });
};

_render_config = function(endpoints){
  var ctx
  ,   new_vcl
  ;

  ctx = {
    routers: endpoints['routers']
  };

  new_vcl = vcl_template(ctx);
  _update_config(new_vcl);
};

_update_config = function(new_vcl){
  Fs.writeFile(process.env['ALICE_VARNISH_VCL'], new_vcl, 'utf8', function(err){
    if (err) {
      console.log('Got error: '+err.message);
      return;
    }
  });
};

process.env['ALICE_VARNISH_VCL'] = process.env['ALICE_VARNISH_VCL'] || '/etc/varnish/default.vcl';

Fs.readFile(__dirname+'/templates/varnish.vcl', 'utf8', function(err, data){
  if (err) throw err;
  vcl_template = Handlebars.compile(data);

  setInterval(_fetch_endpoints, 60000);
});
