
CXX=/home/soos/development/smt/klee/scripts/klee-clang cmake  -DNOM4RI=ON  -DNOVALGRIND=ON ..
/home/soos/development/smt/klee/scripts/klee-clang -DKLEE -std=c++11 -I../ ../tests/distill_klee.cpp -o klee.o
llvm-link-3.4 lib/libcryptominisat4.so /home/soos/development/smt/libcxx/build/lib/libc++.so.1.0 klee.o -o out
klee --libc=uclibc --posix-runtime out


http://mailman.ic.ac.uk/pipermail/klee-dev/2014-May/000703.html :
- Use uClibc++
- Strip as much as possible of the interaction with the outside world (posix)


clang++-3.4 -fno-builtin -nostdinc++

soos@masoos:~/development/smt/libcxx/build:
    CXX=/home/soos/development/smt/klee/scripts/klee-clang cmake -DCMAKE_C_COMPILER=clang-3.4 -DCMAKE_CXX_COMPILER=clang++-3.4 ..
    CXX=/home/soos/development/smt/klee/scripts/klee-clang cmake -DCMAKE_C_COMPILER=/home/soos/development/smt/klee/scripts/klee-clang -DCMAKE_CXX_COMPILER=/home/soos/development/smt/klee/scripts/klee-clang ..


/home/soos/development/smt/libcxx/build/include/c++/v1