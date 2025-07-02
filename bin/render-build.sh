#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Installing dependencies..."
bundle install

echo "Precompiling assets..."
bundle exec rake assets:precompile
bundle exec rake assets:clean

echo "Creating schemas in the same database..."
bundle exec rails runner "
  ActiveRecord::Base.connection.execute('CREATE SCHEMA IF NOT EXISTS cache;')
  ActiveRecord::Base.connection.execute('CREATE SCHEMA IF NOT EXISTS queue;')
  ActiveRecord::Base.connection.execute('CREATE SCHEMA IF NOT EXISTS cable;')
"

echo "Running migrations for primary database..."
bundle exec rake db:migrate

echo "Running migrations for cache schema..."
bundle exec rake db:migrate:cache

echo "Running migrations for queue schema..."
bundle exec rake db:migrate:queue

echo "Running migrations for cable schema..."
bundle exec rake db:migrate:cable

echo "Build completed successfully!"
