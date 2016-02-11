#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
cmake -DENABLE_PYTHON_INTERFACE=ON ..
make -j6
cd ../tests/simp-checks/
./checks.py ../../build/cryptominisat4 testfiles/*
cd ../../build/
