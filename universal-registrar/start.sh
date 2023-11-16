#!/bin/env sh

redis-server &
cd /app
yarn
node restroom.mjs
