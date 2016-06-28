#!/bin/bash
set -e
set -x

../../cnf-utils/build/cnf-fuzz-biere > tmp.cnf
./cryptominisat5 -p 1 tmp.cnf simplified.cnf
./cryptominisat5 simplified.cnf > solution.txt
./cryptominisat5 -p 2 solution.txt

