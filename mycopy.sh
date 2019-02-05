#!/usr/bin/bash

set -x
set -e
scp rem_data.py add_lemma_ind.py combine_dats.py predict.py gen_pandas.py nscc:/home/projects/11000744/matesoos/cryptominisat5-predict-main
scp ../scripts/output_parser/concat_files.py ../scripts/output_parser/solved_with_options.sh ../scripts/output_parser/solvetimes_from_output.sh nscc://home/projects/11000744/matesoos/cryptominisat5-main/
