#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
cmake -DENABLE_TESTING=ON -DREQUIRE_M4RI=ON -DSTATICCOMPILE=ON ..
make -j6 VERBOSE=1
make test
cd ../tests/simp-checks/
./check_bve.py ../../build/cryptominisat5 testfiles/*
cd ../../build/
