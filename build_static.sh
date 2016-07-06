#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
cmake -DENABLE_TESTING=ON -DREQUIRE_M4RI=ON -DSTATICCOMPILE=ON -DENABLE_PYTHON_INTERFACE=OFF -DNOVALGRIND=ON -DCMAKE_BUILD_TYPE=Release -DENABLE_TESTING=OFF ..
make -j6 VERBOSE=1
