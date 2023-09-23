#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
cmake -DENABLE_PYTHON_INTERFACE=OFF -DSTATICCOMPILE=ON ..
make -j6 VERBOSE=1
strip cryptominisat5
