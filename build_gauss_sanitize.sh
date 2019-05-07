#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include scalmc* cusp*
rm -rf tests
CXX=clang++ cmake -DUSE_GAUSS=ON -DENABLE_TESTING=ON -DSANITIZE=ON ..
make -j6
make test
