#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests cusp* scalmc*
scan-build cmake -DENABLE_PYTHON_INTERFACE=ON -DENABLE_TESTING=ON ..
scan-build make -j6
make test
cd ../tests/simp-checks/
./checks.py ../../build/cryptominisat5 testfiles/*
cd ../../build/
