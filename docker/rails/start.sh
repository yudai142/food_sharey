#!/bin/bash
set -e

# Remove pid file if exists
rm -f /app/tmp/pids/server.pid

# Create database if it doesn't exist (for production environment)
if [ "$RAILS_ENV" = "production" ]; then
  echo "Creating database if not exists..."
  bundle exec rails db:create 2>&1 || true
fi

echo "Running database migrations..."
bundle exec rails db:migrate 2>&1 || true

# Check if assets were precompiled during build
echo "Checking precompiled assets..."
if [ -d "public/assets" ]; then
  echo "✓ Precompiled assets directory found"
  ls -la public/assets/ | head -10
else
  echo "⚠ Warning: Precompiled assets directory not found"
  if [ "$RAILS_ENV" = "production" ]; then
    echo "Attempting to precompile assets at runtime..."
    bundle exec rails assets:precompile 2>&1
  fi
fi

# Start Puma server
echo "Starting Puma server..."
exec bundle exec puma -C config/puma.rb
