#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
cmake -DNOTBUDDY=OFF -DENABLE_TESTING=OFF -DREQUIRE_M4RI=OFF -DSTATICCOMPILE=ON -DNOBREAKID=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
make -j26
strip cryptominisat5
