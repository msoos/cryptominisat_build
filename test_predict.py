#!/bin/bash
set -e
set -x

rm -if dratout
rm -if drat_test2.cnf.gz.sqlite
./cryptominisat4 --verb 0 drat_test2.cnf.gz --zero-exit-status --clid drat_out --sql 2
../../drat-trim2/drat-trim2 drat_test2.cnf.gz drat_out -l lemmas
./add_lemma_ind.py drat_test2.cnf.gz.sqlite lemmas
./predict.py drat_test2.cnf.gz.sqlite
dot -Tpng drat_test2.tree,dot -o tree.png
okular tree.png