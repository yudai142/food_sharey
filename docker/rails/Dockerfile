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
RUN NODE_ENV=production yarn build

# Generate empty master key for asset precompilation if needed
RUN mkdir -p config && \
    touch config/master.key && \
    echo "0" > config/master.key || true

# Precompile assets for production (with proper error handling)
RUN echo "Starting asset precompilation..." && \
    bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=0000000000000000000000000000000000000000000 && \
    echo "Asset precompilation completed successfully" && \
    ls -lah public/assets/ && \
    echo "Assets directory structure:" && \
    find public/assets -type f | head -20

COPY docker/rails/start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["/start.sh"]

EXPOSE 0
