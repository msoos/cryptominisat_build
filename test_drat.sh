#!/bin/bash
set -e
set -x

./cryptominisat4 --drat=drat_test.drat --input=drat_test.cnf --zero-exit-status
cat drat_test.drat
../../drat-trim/drat-trim drat_test.cnf drat_test.drat 
