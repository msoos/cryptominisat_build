#!/bin/bash
set -e
set -x

strip cryptominisat4
strip lib/libcryptominisat*so*

cp lib/libcryptominisat4.so  lib/libcryptominisat4.so.4.5  /usr/local/lib/libm4ri-0.0.20111203.so ../scripts/docker
cd ../scripts/docker/
docker build -t msoos/cryptominisat:v2 .
# docker run msoos/cryptominisat:v2
# docker rm `docker ps --no-trunc -aq`
# docker run -ti -v $(pwd)/data:/home/data  msoos/cryptominisat:v2 ./cryptominisat4 --sql 2 data/mizh-md5-47-3.cnf.gz
