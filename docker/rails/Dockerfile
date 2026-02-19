FROM ruby:3.1-bullseye

ENV RAILS_ENV=production
ENV TZ Asia/Tokyo

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn
RUN apt-get update -qq && \
  apt-get install -y apt-utils \
  build-essential \
  libpq-dev \
  vim \
  default-mysql-client
WORKDIR /app
COPY . /app
RUN bundle config --local set path 'vendor/bundle' \
  && bundle install -j4
RUN yarn install --ignore-engines

# Build JavaScript and CSS with esbuild (CRITICAL: must run before assets:precompile)
RUN echo "=== Building assets with esbuild ===" && \
    NODE_ENV=production yarn build && \
    echo "✓ yarn build completed" && \
    echo "Checking app/assets/builds directory:" && \
    ls -lah app/assets/builds/ 2>/dev/null || echo "Directory not found yet"

# Generate empty master key for asset precompilation if needed
RUN mkdir -p config && \
    touch config/master.key && \
    echo "0" > config/master.key || true

# Accept SECRET_KEY_BASE from build args (from Render environment)
ARG SECRET_KEY_BASE=0000000000000000000000000000000000000000000
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Precompile assets for production (skip database connection)
RUN echo "=== Starting Rails asset precompilation ===" && \
    RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails assets:precompile --trace 2>&1 && \
    echo "✓ Asset precompilation completed successfully" && \
    echo "Assets directory contents:" && \
    find public/assets -type f | head -30 || echo "⚠ No assets found in public/assets"

COPY docker/rails/start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["/start.sh"]

EXPOSE 0
