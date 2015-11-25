#!/bin/bash                                                                                                                            

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include
rm -rf tests

CXX=/home/soos/development/smt/klee/scripts/klee-clang cmake -DNOM4RI=ON  -DNOVALGRIND=ON -DNOZLIB=ON  -DONLY_SIMPLE=ON  -DENABLE_PYTHON_INTERFACE=OFF ..
make -j4
