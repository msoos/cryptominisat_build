#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
cmake -DENABLE_TESTING=ON -DREQUIRE_M4RI=ON -DSTATICCOMPILE=ON ..
make -j16 VERBOSE=1
strip cryptominisat5
