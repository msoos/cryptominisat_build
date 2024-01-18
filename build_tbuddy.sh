#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests cusp* scalmc* utils Make*
cmake -DFORCETBUDDY=ON -DNOBREAKID=OFF -DNOBOSPHORUS=ON -DENABLE_TESTING=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
make -j26
make test
