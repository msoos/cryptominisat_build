#!/bin/bash
set -e
set -x

rm -if dratout
rm -if drat_test2.cnf.gz.sqlite
status=`./cryptominisat5 --hhelp | grep sql || ret=$?`
if [ "$ret" -ne 0 ]; then
    echo "You must compile SQL into cryptominisat"
    exit -1
fi

# running CNF
./cryptominisat5 --verb 0 drat_test2.cnf.gz --maxtemp 1000000000 --keepguess 0 --zero-exit-status --clid --sql 2 drat_out

# getting drat
../../drat-trim/drat-trim drat_test2.cnf.gz drat_out -l lemmas

# add lemma indices that were good
./add_lemma_ind.py drat_test2.cnf.gz.sqlite lemmas

# run prediction on SQLite database
./predict.py drat_test2.cnf.gz.sqlite

# generate DOT and display it
dot -Tpng drat_test2.tree.dot -o tree.png
okular tree.png
