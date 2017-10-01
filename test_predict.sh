#!/bin/bash
set -e
set -x

status=`./cryptominisat5 --hhelp | grep sql || ret=$?`
if [ "$ret" -ne 0 ]; then
    echo "You must compile SQL into cryptominisat"
    exit -1
fi

OUTDIR="test_predict"
mkdir -p ${OUTDIR}

rm -if ${OUTDIR}/drat_out
rm -if ${OUTDIR}/lemmas
rm -if ${OUTDIR}/*.sqlite

# running CNF
./cryptominisat5 --verb 0 drat_test2.cnf.gz --keepguess 0 --zero-exit-status --clid --sql 2 --sqlitedb ${OUTDIR}/data.sqlite ${OUTDIR}/drat_out

# getting drat
../../drat-trim/drat-trim drat_test2.cnf.gz ${OUTDIR}/drat_out -l ${OUTDIR}/lemmas

# add lemma indices that were good
./add_lemma_ind.py ${OUTDIR}/data.sqlite ${OUTDIR}/lemmas

# run prediction on SQLite database
./predict.py ${OUTDIR}/data.sqlite

# generate DOT and display it
dot -Tpng ${OUTDIR}/data.tree.dot -o tree.png
okular tree.png
