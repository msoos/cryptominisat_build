#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
cmake -DLARGEMEM=ON -DNOTBUDDY=ON -DENABLE_TESTING=OFF -DSTATICCOMPILE=ON -DNOBREAKID=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
make -j26
strip cryptominisat5
