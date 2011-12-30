
director routers round-robin {
  {{#routers}}
  {
    .backend = {
      .host = "{{host}}";
      .port = "{{port}}";
      .probe = {
        .url       = "/_alice/probe/router";
        .timeout   = 50ms;
        .interval  = 1s;
        .window    = 10;
        .threshold = 8;
      }
    }
  }
  {{/routers}}
}


acl purge {
  "localhost";
}


sub vcl_recv {
  if (req.request == "PURGE") {
    if (!client.ip ~ purge) {
      error 405 "Not allowed.";
    }
    return (lookup);
  }

  set req.backend = routers;

  if (req.restarts == 0) {
    if (req.http.x-forwarded-for) {
      set req.http.X-Forwarded-For =
          req.http.X-Forwarded-For + ", " + client.ip;
    } else {
      set req.http.X-Forwarded-For = client.ip;
    }
  }

  if (req.http.Accept-Encoding) {
    if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)(\?\d+)?$") {
      # No point in compressing these
      remove req.http.Accept-Encoding;
    } elsif (req.http.Accept-Encoding ~ "gzip") {
      set req.http.Accept-Encoding = "gzip";
    } elsif (req.http.Accept-Encoding ~ "deflate") {
      set req.http.Accept-Encoding = "deflate";
    } else {
      # unkown algorithm
      remove req.http.Accept-Encoding;
    }
  }

  if (req.request != "GET"     &&
      req.request != "HEAD"    &&
      req.request != "PUT"     &&
      req.request != "POST"    &&
      req.request != "TRACE"   &&
      req.request != "OPTIONS" &&
      req.request != "DELETE") {
    /* Non-RFC2616 or CONNECT which is weird. */
    return (pipe);
  }

  # pipe SSE
  if (req.http.Accept == "text/event-stream") {
    return (pipe);
  }

  # pipe WS
  if (req.http.upgrade ~ "(?i)websocket") {
    return (pipe);
  }

  if (req.request != "GET" && req.request != "HEAD") {
    /* We only deal with GET and HEAD by default */
    return (pass);
  }

  if (req.url ~ "^/lalala") {
    /* Not cacheable by default */
    return (pass);
  }

  if (req.http.Cookie) {
    set req.http.Cookie = regsuball(req.http.Cookie, "__utm.=[^;]+(; )?", "");
    if (req.http.Cookie ~ "^ *$") {
      remove req.http.Cookie;
    }
    if (req.url ~ "^/_fragments") {
      remove req.http.Cookie;
    }
  }

  if (req.request == "GET" && req.url ~ "\.(css|js|gif|jpg|jpeg|bmp|png|ico|img|tga|wmf)(\?\d+)?$") {
    remove req.http.Cookie;
    return(lookup);
  }

  if (req.http.Authorization || req.http.Cookie) {
    /* Not cacheable by default */
    return (pass);
  }

  return(lookup);
}

sub vcl_pipe {
  if (req.http.upgrade) {
    set bereq.http.upgrade = req.http.upgrade;
  }

  # Note that only the first request to the backend will have
  # X-Forwarded-For set.  If you use X-Forwarded-For and want to
  # have it set for all requests, make sure to have:
  # set bereq.http.connection = "close";
  # here.  It is not set by default as it might break some broken web
  # applications, like IIS with NTLM authentication.
  return (pipe);
}

sub vcl_pass {
  return (pass);
}

sub vcl_hash {
  hash_data(req.url);

  if (req.http.host) {
    hash_data(req.http.host);
  } else {
    hash_data(server.ip);
  }

  return (hash);
}

sub vcl_hit {
  if (req.request == "PURGE") {
    purge;
    error 200 "Purged. (HIT)";
  }

  if (req.http.Cache-Control ~ "no-cache") {
    # Ignore requests via proxy caches,  IE users and badly behaved crawlers
    # like msnbot that send no-cache with every request.
    if (! (req.http.Via || req.http.User-Agent ~ "bot|MSIE")) {
      set obj.ttl = 0s;
      return (restart);
    }
  }

  return (deliver);
}

sub vcl_miss {
  if (req.request == "PURGE") {
    purge;
    error 200 "Purged. (MISS)";
  }

  return (fetch);
}

sub vcl_fetch {
  unset beresp.http.Server;
  set beresp.http.Server = "Mr. Server";

  if (beresp.http.Content-Type ~ "^text\/" ||
      beresp.http.Content-Type ~ "^application\/json" ||
      req.url                  ~ "\.(css|js)(\?\d+)?$") {
    set beresp.do_gzip = true;
    # this should only happen for non authenticated URI's

    # if (!(req.url ~ "^/lalala" || beresp.http.Set-Cookie)) {
    #   set beresp.http.Cache-Control = "max-age=600,public";
    # }
  }

  if (beresp.http.Content-Type ~ "^text\/html") {
    set beresp.do_esi = true;
  }

  if (req.url ~ "^/lalala") {
    return (deliver);
  }

  if (req.url ~ "\.(css|js|gif|jpg|jpeg|bmp|png|ico|img|tga|wmf)(\?\d+)?$") {
    unset beresp.http.Set-Cookie;
    set beresp.http.Cache-Control = "max-age=31536000,public";

    # if (beresp.ttl < 3600s) {
    #  set beresp.ttl = 600s;
    # }
  }

  if (beresp.ttl <= 0s ||
      beresp.http.Set-Cookie ||
      beresp.http.Vary == "*") {
    /*
     * Mark as "Hit-For-Pass" for the next 2 minutes
     */
    set beresp.ttl = 120s;
    return (hit_for_pass);
  }

  return (deliver);
}

sub vcl_deliver {
  if (obj.hits > 0) {
    set resp.http.X-Cache = "HIT";
  } else {
    set resp.http.X-Cache = "MISS";
  }

  remove resp.http.X-Powered-By;
  remove resp.http.X-Varnish;
  remove resp.http.Via;

  return (deliver);
}

