#!/bin/bash

input=$1
id=$2
log='samples/out_'$id'.log'
output='samples/out_'$id'.mp4'

#debug='samples/debug.log'
debug='/dev/null'

echo 'input: ' $input >> $debug
echo 'id: ' $id >> $debug
echo 'log: ' $log >> $debug
echo 'output: ' $output >> $debug

HandBrakeCLI --json --input=$input --output=$output \
    --encoder=x264 \
    #--encoder=x265 \
    --encoder-preset=fast --encoder-profile=auto \
    --quality=18.0 --aencoder=copy 1> $log 2> /dev/null

cat $log >> $debug

rm $log
