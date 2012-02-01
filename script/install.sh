export rvm_project_rvmrc=0
export rvm_pretty_print=0
[[ -f /usr/local/rvm/scripts/rvm ]] && RVM_BOOT=/usr/local/rvm/scripts/rvm
[[ -f $HOME/.rvm/scripts/rvm     ]] && RVM_BOOT=$HOME/.rvm/scripts/rvm
[[ "x" != "x$RVM_BOOT"           ]] && . $RVM_BOOT

. ./.rvmrc

bundle install                          \
  --gemfile     Gemfile                 \
  --path        vendor/bundle           \
  --deployment                          \
  --quiet                               \
  --without     development test deploy
