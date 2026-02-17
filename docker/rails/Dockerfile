FROM ruby:2.7-bullseye

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

COPY docker/rails/start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["/start.sh"]

EXPOSE 5000
