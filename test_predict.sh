#!/bin/bash
set -e
set -x

./predict_one.sh drat_test2.cnf.gz

dot -Tpng predict/data.sqlite.tree.dot -o tree.png
echo "Execute:"
echo "okular tree.png"
