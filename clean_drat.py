#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import sys

if len(sys.argv) != 2:
    print("Error: must give file to parse")
    exit(-1)

fname = sys.argv[1]

f = open("my_test.drup")
for line in f:
    line = line.strip()
    toprint = ""
    zeros = 0
    for e in line.split():
        e = e.strip()
        if e == "d":
            toprint += "d "
            continue

        # print("e is %s" % e)
        if int(e) == 0:
            zeros += 1
            toprint += "0"
            break

        toprint += "%d " % int(e)

    print(toprint)

f.close()
