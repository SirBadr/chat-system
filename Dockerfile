FROM ruby:2.4-slim

RUN apt-get update
RUN apt-get install -y --no-install-recommends nodejs libmariadb-dev\
  build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev \
  curl
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile* ./
RUN bundle install

COPY . .

ENV RAILS_ENV development

EXPOSE 3000