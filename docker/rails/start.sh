#!/bin/bash
set -e

# Remove pid file if exists
rm -f /app/tmp/pids/server.pid

# Precompile assets (run once on startup)
if [ "$RAILS_ENV" = "production" ]; then
  echo "Precompiling assets..."
  bundle exec rails assets:precompile --trace
fi

# Start Puma server
exec bundle exec puma -C config/puma.rb
