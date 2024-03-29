#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests cusp* scalmc*
emcmake cmake -DENABLE_PYTHON_INTERFACE=OFF \
    -DENABLE_TESTING=OFF -DNOZLIB=ON \
    -DEMSCIPTEN=ON \
    ..
make VERBOSE=1 -j4
