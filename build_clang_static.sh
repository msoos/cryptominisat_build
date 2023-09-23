#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
CXX=clang++ cmake -DENABLE_TESTING=ON -DSTATICCOMPILE=ON ..
make -j6
make test
