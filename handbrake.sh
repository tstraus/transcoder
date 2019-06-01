#!/bin/bash

input='samples/in.mp4'
id=$1
log='samples/out_'$id'.log'
output='samples/out_'$id'.mp4'

HandBrakeCLI --json --input=$input --output=$output --encoder=x264 --encoder-preset=fast --encoder-profile=auto --quality=18.0 --aencoder=copy 1> $log 2> /dev/null

rm $log
