# Router

# Downstream protocol support

- HTTP
- WebSockets
- SSE
- SPDY

# Upstream protocol support

- HTTP 1.1
- HTTPS
- SPDY
- SSE
- WebSockets
- FastCGI


## Level 0 - Varnish

Takes every thing on port 80 and forwards it to a pool of Level 1
routers.

## Level 1 - Machine router

Takes every thing on port 8081 and forwards it based on a HOST-PATH
conbination to the right L2 router (Usualy on a differet machine).

## Level 2 - Application router

Takes every thing on port 8080 and forwards it based on a HOST-PATH
conbination to the right L3 router.

## Level 3 - Task router

- Static files -> Apache
- PHP          -> Apache
- Ruby         -> Thin/Mongrel/Webbrick
- Node         -> Node


# Redis DB

    hosts:mrhenry.be:app
    apps:client_mrhenry:maintenance
    apps:client_mrhenry:backends-list
    machines:machine-003:endpoints-list

# .router.js

```js

if (is_websocket())  { route('rails'); }
if (is_sse_stream()) { route('rails'); }
if (path_info == '/favicon.ico') { route('static'); }
if (

```

```

when(websocket).forward('rails');
when(path_is('/favicon.ico')).forward('static');
when(prefix('/system')).forward('static');
when(prefix('/blog/wp-content/wp-uploads').chroot
when(prefix('/blog')).chroot('/blog').forward('wordpress');

```

```
map '/' do

  get '/system/*', to: backend('static')
  map websockets,  to: backend('rails')

end

map '/blog' do

  rewrite %r{/blog(.*)}, to: '\1'
  chroot  '/blog'

  get '/wp-content/wp-uploads/*', to: backend('static')
  map '/*',                       to: backend('wordpress')

end
```

```
static:
  /system
  /blog/wp-content/wp-uploads
  @assets

wordpress:
  /blog [root=/blog]

rails:
  /
```


```
mount(:static, 'public/*',       as: '/')
mount(:static, 'public/system/', as: '/system/')
```

```
[public/(.+)] /$1                         @static
              /system                     @static
              /blog/wp-content/wp-uploads @static
              /blog                       @wordpress
              /                           @rails
```

```ruby

files('public/**') do |path|
  next if %r{^public/system} === path
  %r{^public/(.+)} === path
  map($1).chroot('public').to('static')
end

map(%r{^/system/.+}).chroot('public').to('static')

map(%r{^/blog/wp-content/wp-uploads}).chroot('wp-blog').to('static')
map(%r{^/blog}).chroot('wp-blog').to('wordpress')
map(%r{^/}).to('rails')

```

# Router


A request comes in:

```
GET /hello/world.html
Host: www.blog.example.com
```

The router does a lookup in the `_global` routing table

```
redis> HMGET routing_table:_global www.blog.example.com. *.www.blog.example.com. *.blog.example.com. *.example.com. *.com. *.
0) NULL
1) NULL
2) "lookup-path example-blog"
3) "lookup-path example"
4) NULL
5) "lookup-path catch-all"
```

The router make a jump to the `example-blog` router table and does a new
lookup.

```
redis> HMGET routing_table:example-blog /hello/world.html /hello/world.html/* /hello/* /*
0) NULL
1) NULL
2) "rebase: '/hello' ; forward: 'backend'"
2) "forward: 'other-backend'"
```

```
domain *.blog.example.com {
  path /hello/* {
    rebase:  "/hello";
    forward: "backend";
  }

  path /* {
    forward: "other-backend";
  }
}
```
