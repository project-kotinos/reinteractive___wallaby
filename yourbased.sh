#!/usr/bin/env bash
set -ex
export DEBIAN_FRONTEND=noninteractive
export CI=true
export TRAVIS=true
export CONTINUOUS_INTEGRATION=true
export USER=travis
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RAILS_ENV=test
export RACK_ENV=test
export MERB_ENV=test
export JRUBY_OPTS="--server -Dcext.enabled=false -Xcompile.invokedynamic=false"
apt-get update && apt-get install -y tzdata
# gem install bundler -v 2.0.1
# before_install
gem install bundler -v '< 2'
# install
bundle install --jobs=3 --retry=3
# before_script
#mysql -e 'CREATE DATABASE dummy_test;' -uroot
#psql -c 'CREATE DATABASE dummy_test;' -U postgres
bundle exec rake db:drop
bundle exec rake db:create
curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
chmod +x ./cc-test-reporter
./cc-test-reporter before-build
cat Gemfile.lock
# script
bundle exec rubocop
bundle exec rake --trace db:setup db:migrate
