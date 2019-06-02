#!/bin/bash

input=$1
id=$2
output='samples/out_'$id'.mp4'

#debug='samples/debug.log'
debug='/dev/null'

echo 'input: ' $input >> $debug
echo 'id: ' $id >> $debug
#echo 'log: ' $log >> $debug
echo 'output: ' $output >> $debug

HandBrakeCLI --json \
    --input=$input --output=$output \
    --encoder=x265 \
    --encoder-preset=fast --encoder-profile=auto \
    --quality=18.0 --aencoder=copy

