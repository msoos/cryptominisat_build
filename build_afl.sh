#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
CC=afl-clang-fast CXX=afl-clang-fast++ cmake -DSANITIZE=ON -DENABLE_PYTHON_INTERFACE=OFF -DENABLE_TESTING=OFF -DNOZLIB=ON ..
make -j6
afl-fuzz -m 500 -i afl/testcase_dir/ -o afl/finddings_dir/ ./cryptominisat5
