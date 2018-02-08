#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
CXX=afl-clang-fast++ cmake -DENABLE_PYTHON_INTERFACE=OFF -DENABLE_TESTING=OFF -DNOZLIB=ON ..
make -j6
