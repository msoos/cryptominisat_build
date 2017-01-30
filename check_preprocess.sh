#!/bin/bash
set -e
set -x
set -h

../../cnf-utils/build/cnf-fuzz-biere > tmp.cnf
./cryptominisat5 --printsol 0 --verb 0 -p 1 tmp.cnf --zero-exit-status simplified.cnf
./cryptominisat5 --verb 0 --zero-exit-status simplified.cnf > solution.txt
./cryptominisat5 --printsol 0 --verb 0 -p 2 --zero-exit-status solution.txt
lingeling --witness=0 tmp.cnf
