#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include scalmc* cusp*
rm -rf tests
cmake -DUSE_GAUSS=ON -DENABLE_TESTING=ON -DCMAKE_INSTALL_PREFIX=/usr ..
make -j6
make test
