#!/bin/bash                                                                                                                            

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include
rm -rf tests

CXX=/home/soos/development/smt/klee/scripts/klee-clang cmake -DNOM4RI=ON  -DNOVALGRIND=ON -DNOZLIB=ON  -DONLY_SIMPLE=ON  -DENABLE_PYTHON_INTERFACE=OFF ..
make -j4

/home/soos/development/smt/klee/scripts/klee-clang -DKLEE -std=c++11 -I../ ../tests/distill_klee.cpp -o klee.o
llvm-link-3.4 lib/libcryptominisat4.so /home/soos/development/smt/libcxx/build/lib/libc++.so.1.0 klee.o -o out
klee --libc=uclibc --posix-runtime out
