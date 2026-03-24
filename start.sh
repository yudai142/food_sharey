#!/bin/sh

if [ "${RAILS_ENV}" = "production" ]
then
    # Build CSS and JavaScript with esbuild and Tailwind
    npm run build
    
    # Precompile Rails assets (images, etc)
    bundle exec rails assets:precompile RAILS_ENV=production NODE_ENV=production
fi

bundle exec rails s -p ${PORT:-3000} -b 0.0.0.0
