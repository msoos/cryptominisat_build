#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests cusp* scalmc* utils drat-trim *.cmake Make*
cmake -DNOTBUDDY=ON -DNOBREAKID=ON -DNOBOSPHORUS=ON -DENABLE_PYTHON_INTERFACE=ON -DENABLE_TESTING=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
make -j26
make test
