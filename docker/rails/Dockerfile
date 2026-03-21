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

# Create app/assets/builds directory for build output
RUN mkdir -p app/assets/builds

# Set production environment before building assets
ENV NODE_ENV=production

# Build CSS and JavaScript assets
RUN echo "=== Building assets ===" && \
    npm run build && \
    echo "=== Asset build completed ==="

# Precompile Rails assets (SCSS + Tailwind compilation happens here)
RUN echo "=== Precompiling Rails assets (RAILS_ENV=production) ===" && \
    bundle exec rails assets:precompile RAILS_ENV=production DATABASE_URL=postgresql://localhost/noop && \
    echo "=== Rails asset precompilation completed ===" && \
    echo "=== Verifying built assets ===" && \
    ls -lh app/assets/builds/ && \
    echo "=== Done ===" || (echo "Asset precompilation failed"; exit 1)

# Accept SECRET_KEY_BASE from build arguments (required for production)
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Setup Rails (master key and directories)
RUN mkdir -p config tmp/pids tmp/cache tmp/sockets && \
    echo "${SECRET_KEY_BASE}" > config/master.key && \
    chmod 600 config/master.key

# Verify Rails can find the assets
RUN echo "=== Verifying asset files are accessible ===" && \
    test -f app/assets/builds/application.css && echo "✓ CSS found" || echo "✗ CSS missing" && \
    test -f app/assets/builds/application.js && echo "✓ JS found" || echo "✗ JS missing"

# Copy and setup start script
COPY docker/rails/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

EXPOSE 3000
