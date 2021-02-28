#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests cusp* scalmc* utils drat-trim *.cmake Make*
rm -f ../tests/cnf-files/*sqlite
CXX=clang++ cmake -DSTATS=ON -DENABLE_TESTING=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DSANITIZE=ON ..
make -j16
make test
