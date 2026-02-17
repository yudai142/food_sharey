#!/bin/bash
set -e

# Remove pid file if exists
rm -f /app/tmp/pids/server.pid

# Start Puma server
exec bundle exec puma -C config/puma.rb
