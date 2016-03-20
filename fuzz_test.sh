#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include
cmake -DSLOW_DEBUG=ON -DSANITIZE=ON ..
make -j6 VERBOSE=1
cd ../scripts/
./fuzz_test.py --small
