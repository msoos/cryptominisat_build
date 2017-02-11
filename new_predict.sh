#!/bin/bash
set -e
set -x

OUTDIR="out_predict_new"
rm -rf ${OUTDIR}
mkdir -p ${OUTDIR}
for i in `seq 1 6`;
do
    FNAME="my_cnf_$i.cnf"
    rm -if dratout
    rm -f lemmas
    rm -f "${FNAME}"

    # generate CNF
    if [ $((a%2)) -eq 0 ];
    then
         ../build/tests/cnf-utils/sgen4 -unsat -n 62 -s 1 > $FNAME
    fi

    if [ $((a%2)) -eq 1 ];
    then
        ../../sha1-sat/build/sha1-gen --attack preimage --rounds 16 --message-bits 430 --zero --seed ${i} > "${FNAME}"
    fi

    # running CNF
    # --maxtemp 1000000000 --presimp 0 --schedsimp 0
    ./cryptominisat5 --verb 0 --keepguess 0 --zero-exit-status --clid --sql 2 "${FNAME}" drat_out

    # getting drat
    ../../drat-trim/drat-trim2 "${FNAME}" drat_out -l lemmas

    # add lemma indices that were good
    mv "${FNAME}.sqlite" "${OUTDIR}/"
    ./add_lemma_ind.py "${OUTDIR}/${FNAME}.sqlite" lemmas
    echo "Done with $i"
done


# run prediction on SQLite database
./predict.py ${OUTDIR}/*.sqlite

# generate DOT and display it
dot -Tpng drat_test2.tree.dot -o tree.png
okular tree.png
