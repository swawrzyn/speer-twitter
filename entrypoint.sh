#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
if [[ $RAILS_ENV == "production" ]]; then
  echo "Speer Twitter Rails Backend -- mode: PRODUCTION"
  rake db:exists && rails db:migrate || rails db:setup
  exec "$@"
else
  echo "Speer Twitter Rails Backend"
  exec "$@"
fi
