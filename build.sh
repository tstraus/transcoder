#!/bin/bash

echo "----- building server -----"
shards install
crystal build --release ./src/transcoder.cr
echo "----- done server -----"

echo "----- building website -----"
npm install
echo "----- done website -----"
