#!/bin/sh

echo "Starting server"
cd /myapp/
rm -f tmp/pids/server.pid
bundle exec rails s -p 80 -b 0.0.0.0