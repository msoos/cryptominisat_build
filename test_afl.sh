#!/bin/bash

set -e

rm -rf cm* CM* lib* cryptomini* Testing* tests* pycryptosat include tests cusp* scalmc*
CXX=afl-g++ cmake -DLIMITMEM=ON ..
make -j6

rm -ir input
mkdir -p input
echo "p cnf 40 40
1 2 0
c dsafdsf
3 4 5 -2 0
x -1 0
c Solver::solve( -1 2 3 )
3 4 0
c Solver::simplify( -2 )
x -5 0
c Solver::solve( )
10 -3 0
c Solver::new_var()
5 -3 0
c Solver::simplify()
c Solver::new_vars( 30 )
20 4 0
" > input/a
# rm -ir output
if [ -d "output" ]; then
    mv output old_output
fi

AFL_SKIP_CPUFREQ=1 afl-fuzz -i input -o output -M master ./cryptominisat5 --debuglib 1
