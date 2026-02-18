#!/bin/bash
set -e

# Remove pid file if exists
rm -f /app/tmp/pids/server.pid

# Create database if it doesn't exist (for production environment)
if [ "$RAILS_ENV" = "production" ]; then
  echo "Creating database if not exists..."
  bundle exec rails db:create 2>&1 || true
  
  echo "Running database migrations..."
  bundle exec rails db:migrate 2>&1 || true
fi

# Start Puma server
exec bundle exec puma -C config/puma.rb
