#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests
cmake -DNOTBUDDY=OFF -DNOBREAKID=ON -DNOBOSPHORUS=ON -DENABLE_PYTHON_INTERFACE=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
make -j12
