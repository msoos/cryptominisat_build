#!/usr/bin/env bash
set -euo pipefail

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests utils Make* .cmake
cmake -DNOBREAKID=ON -DENABLE_TESTING=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
make -j26
ctest --rerun-failed --output-on-failure
