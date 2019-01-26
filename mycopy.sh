#!/usr/bin/bash

set -x
set -e
scp gen_pandas.py nscc:/home/projects/11000744/matesoos/cryptominisat5-predict-main
scp rem_data.py add_lemma_ind.py nscc:/home/projects/11000744/matesoos/cryptominisat5-predict-main
scp ../scripts/output_parser/solvetimes_from_output.sh nscc://home/projects/11000744/matesoos/cryptominisat5-main/
