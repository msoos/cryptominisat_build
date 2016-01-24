#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
cmake -DENABLE_PYTHON_INTERFACE=ON -DENABLE_TESTING=ON ..
make -j4
make test
cd ../tests/simp-checks/
./checks.py ../../build/cryptominisat4 testfiles/*
cd ../../build/
