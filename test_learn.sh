#!/bin/bash
set -e
set -x

rm -if dratout
rm -if 6s167-opt.cnf.gz.sqlite
./cryptominisat4 6s167-opt.cnf.gz --sql 2 drat_out
../../drat-trim2/drat-trim2 6s167-opt.cnf.gz drat_out

