FROM ruby:3.2.2-slim

ENV RAILS_ENV=development
ENV BUNDLER_VERSION=2.4.22

# Install OS dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  git \
  curl

# Set working directory
WORKDIR /app

# Copy Gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle install

# Copy the entire app
COPY . .

# Default command
CMD ["bash"]
