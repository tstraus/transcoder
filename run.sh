#!/bin/bash

docker build -t transcoder .
docker run -p 3000:3000 transcoder
