#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import optparse
import os
import subprocess
import copy
import calendar
import time

def check_one_conflict(orig_cnf, clause):

    newf = copy.deepcopy(orig_cnf)
    newf += "\n"
    for lit in clause:
        newf += "%d 0\n" %(-1*lit)

    toexec = "lingeling -f"
    print("Solving with other solver: %s" % toexec)
    currTime = calendar.timegm(time.gmtime())
    p = subprocess.Popen(toexec.rsplit(),
                         stdout=subprocess.PIPE,
                         stdin=subprocess.PIPE)
    console_out = p.communicate(input=newf)[0]
    t = calendar.timegm(time.gmtime()) - currTime
    console_out = map(str.strip, console_out.split('\n'))

    unsat = False
    for line in console_out:
        if "UNSATISFIABLE" in line:
            unsat = True

    if not unsat:
        print("OOOps, this is the issue: %s" % clause)
        exit(-1)

def get_clauses_to_verify(outfname):
    clauses = []
    with open(outfname, "r") as f:
        for line in f:
            line = line.strip()
            if "clause:" not in line:
                continue

            lits = line.split(",")[0].split(" ")[3:][:-1]
            lits = map(int, lits)
            clauses.append(lits)
            if options.verbose:
                print("lits: %s" % lits)

    return clauses

if __name__ == "__main__":
    usage = """usage: %prog [options] CNF gauss_output
Where gauss_output is the outptu of gauss with lines such as:
(0) prop clause: -43 84 27 143 -12 151 , rhs:1
(0) confl clause: -133 102 146 -149 8 -16 -172, rhs: 1

The system will verify each and every clause and check if it's a direct
consequence of the CNF. It exists on the first wrong clause it finds.
"""
    parser = optparse.OptionParser(usage=usage)

    parser.add_option("--verbose", "-v", action="store_true", default=False,
                      dest="verbose", help="Print more output")

    (options, args) = parser.parse_args()

    if len(args) != 2:
        print("ERROR: You must give CNF and output file")
        exit(-1)

    cnffname = args[0]
    outfname = args[1]
    print("CNF: %s output file: %s" % (cnffname, outfname))

    clauses = get_clauses_to_verify(outfname)

    origf = ""
    with open(cnffname, "r") as f:
        origf = f.read()

    for clause in clauses:
        print("Checking clause %s" % clause)
        check_one_conflict(origf, clause)
