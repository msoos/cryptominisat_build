#!/bin/bash
set -e
set -x

../../cnf-utils/build/cnf-fuzz-biere > tmp.cnf
./cryptominisat4 -p 1 tmp.cnf simplified.cnf
./cryptominisat4 simplified.cnf > solution.txt
./cryptominisat4 -p 2 solution.txt

