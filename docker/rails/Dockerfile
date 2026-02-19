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

# Generate master key for credentials (required for Rails 7)
RUN mkdir -p config && \
    echo "0000000000000000000000000000000000000000000" > config/master.key && \
    chmod 600 config/master.key

# Accept SECRET_KEY_BASE from build args (from Render environment)
ARG SECRET_KEY_BASE=0000000000000000000000000000000000000000000
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Create public directory if not exists
RUN mkdir -p public/assets

# Accept SECRET_KEY_BASE from build args (from Render environment)
ARG SECRET_KEY_BASE=0000000000000000000000000000000000000000000
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Verify esbuild outputs in app/assets/builds
RUN echo "=== Verifying esbuild outputs ===" && \
    ls -lah app/assets/builds/ && \
    echo "✓ esbuild complete"

# Copy esbuild outputs to public/assets
RUN echo "=== Copying esbuild assets to public ===" && \
    mkdir -p public/assets && \
    cp -r app/assets/builds/* public/assets/ 2>/dev/null && \
    echo "✓ esbuild assets copied"

# Copy image assets to public for Rails to serve
RUN echo "=== Copying image assets ===" && \
    mkdir -p public/assets/images && \
    cp -r app/assets/images/* public/assets/images/ 2>/dev/null && \
    echo "✓ Image assets ready"

COPY docker/rails/start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["/start.sh"]

EXPOSE 0
