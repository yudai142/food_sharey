#!/bin/bash
set -e

# Remove pid file if exists
rm -f /app/tmp/pids/server.pid

# Generate master.key from SECRET_KEY_BASE environment variable if provided
if [ -n "$SECRET_KEY_BASE" ]; then
  echo "Setting up master.key from SECRET_KEY_BASE..."
  echo "$SECRET_KEY_BASE" > /app/config/master.key
  chmod 600 /app/config/master.key
fi

# Create database if it doesn't exist (for production environment)
if [ "$RAILS_ENV" = "production" ]; then
  echo "Creating database if not exists..."
  bundle exec rails db:create 2>&1 || true
fi

echo "Running database migrations..."
bundle exec rails db:migrate 2>&1 || true

# Assets should be precompiled during Docker build
# Do NOT attempt to precompile at runtime to avoid SCSS path issues
echo "✓ Skipping runtime asset precompilation (should be done at build time)"

# Start Puma server
echo "Starting Puma server..."
exec bundle exec puma -C config/puma.rb
