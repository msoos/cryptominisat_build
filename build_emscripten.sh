#!/bin/bash

set -e
rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests utils Make*
emcmake cmake -DCMAKE_INSTALL_PREFIX=$EMINSTALL ..
emmake make -j12
emmake make install
