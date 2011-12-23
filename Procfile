web:    bundle exec rails server thin -p $PORT
prober: node proxy/prober.js
router: node proxy/router.js $PORT
passer: node proxy/passer.js $PORT
