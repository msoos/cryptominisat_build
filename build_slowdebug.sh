#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include
cmake -DCMAKE_BUILD_TYPE=Debug -DENABLE_TESTING=ON -DSLOW_DEBUG=ON ..
make -j26 VERBOSE=1
make test
