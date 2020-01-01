#!/bin/bash

BUILD_TYPE="--debug"

if [[ $1 = "-r" ]]; then
    BUILD_TYPE="--release"
fi

shards install
crystal build $BUILD_TYPE ./src/transcoder.cr

