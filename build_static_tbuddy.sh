#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests cusp* scalmc* utils Make*
cmake -DSTATICCOMPILE=ON -DFORCETBUDDY=ON -DNOBREAKID=ON -DNOBOSPHORUS=ON -DENABLE_TESTING=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
make -j26
make test
