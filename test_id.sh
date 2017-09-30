#!/bin/bash
set -e
set -x

rm -f test_id.drat*
rm -f lemmas
rm -f core

echo ""
echo "Solving..."
./cryptominisat5 --clid --verb 0 test_id.cnf test_id.drat --zero-exit-status


echo ""
echo "CHANGED DRAT:"
./tests/drat-trim/drat-trim test_id.cnf test_id.drat -c core -l lemmas

echo ""
echo "DRAT NORM:"
./clean_drat.py test_id.drat > test_id.drat2
./tests/drat-trim/drat-trim test_id.cnf test_id.drat2

diff -y test_id.drat test_id.drat2 | head -n 10
