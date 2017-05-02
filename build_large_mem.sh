#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests cusp* scalmc*
cmake -DLARGEMEM=ON -DENABLE_PYTHON_INTERFACE=ON -DENABLE_TESTING=ON ..
make -j6
make test
(
    cd ../tests/simp-checks/
    ./check_bve.py ../../build/cryptominisat5 testfiles/*
)
