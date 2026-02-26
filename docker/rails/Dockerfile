FROM ruby:3.1-bullseye

ENV RAILS_ENV=production
ENV TZ=Asia/Tokyo

# Install Node.js and build utilities
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update -qq && \
    apt-get install -y nodejs && \
    apt-get install -y apt-utils build-essential libpq-dev vim default-mysql-client && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy application code
COPY . /app

# Install Ruby dependencies
RUN bundle config --local set path 'vendor/bundle' && \
    bundle install -j4 --no-cache

# Install Node dependencies (including devDependencies for build tools)
RUN npm install

# Set production environment and build assets
ENV NODE_ENV=production
RUN npm run build

# Setup Rails (master key and directories)
RUN mkdir -p config tmp/pids tmp/cache tmp/sockets && \
    echo "${SECRET_KEY_BASE:-0000000000000000000000000000000000000000000}" > config/master.key && \
    chmod 600 config/master.key

# Accept SECRET_KEY_BASE from build arguments
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Verify assets were built
RUN ls -lh app/assets/builds/

# Copy and setup start script
COPY docker/rails/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

EXPOSE 3000
