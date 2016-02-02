#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import sqlite3
import optparse
import operator

def parse_lemmas(lemmafname):
    ret = []
    with open(lemmafname, "r") as f:
        for line in f:
            if line[0] == "d":
                continue

            line = line.strip()
            l = line.split(" ")
            good_id = l[len(l)-1]
            if options.verbose:
                print(good_id)

            good_id2 = 0
            try:
                good_id2 = int(good_id)
            except:
                print("ERROR: ID %s is not an integer!" % good_id)
                exit(-1)

            if good_id2 > 1:
                ret.append(good_id2)

    print("Parsed %d number of good lemmas" % len(ret))
    ret = sorted(ret)
    return ret

class Query:
    def __init__(self):
        self.conn = sqlite3.connect(dbfname)
        self.c = self.conn.cursor()
        self.runID = self.find_runID()

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.conn.close()

    def find_runID(self):
        q = """
        SELECT runID
        FROM startUp
        order by startTime desc
        limit 1
        """

        runID = None
        for row in self.c.execute(q):
            runID = int(row[0])

        print("runID: %d" % runID)
        return runID

    def add_goods(self, ids):
        self.c.execute('delete from goodClauses;')

        id_b = [(self.runID, x) for x in ids]
        self.c.executemany("""
            INSERT INTO goodClauses (`runID`, `clauseID`)
            VALUES (?, ?)""", id_b)

    def find_goods(self, name):
        q = """
        SELECT clauseStats.{0}, count(clauseStats.{0})
        FROM clauseStats, goodClauses
        WHERE clauseStats.clauseID = goodClauses.clauseID
        and clauseStats.runID = goodClauses.runID
        and clauseStats.runID = {1}
        group by clauseStats.{0}
        """.format(name, self.runID)

        with open("hist-%s-good.dat" % name, "w") as f:
            total=0
            num= 0
            for row in self.c.execute(q):
                total += int(row[0])*int(row[1])
                num += int(row[1])
                f.write("%s\t%s\n" % (row[0], row[1]))

        print("good avg: %-6.2f" % (float(total)/float(num)))

    def find_bads(self, name):
        q = """
        SELECT clauseStats.{0}, count(clauseStats.{0})
        FROM clauseStats left join goodClauses
        on clauseStats.clauseID = goodClauses.clauseID
        and clauseStats.runID = goodClauses.runID
        where goodClauses.clauseID is NULL
        and goodClauses.runID is NULL
        and clauseStats.runID = {1}
        group by clauseStats.{0}
        """.format(name, self.runID)

        with open("hist-%s-bad.dat" % name, "w") as f:
            total=0
            num= 0
            for row in self.c.execute(q):
                total += int(row[0])*int(row[1])
                num += int(row[1])
                f.write("%s\t%s\n" % (row[0], row[1]))

        print("bad  avg: %-6.2f" % (float(total)/float(num)))


if __name__ == "__main__":

    usage = "usage: %prog [options] lemma_file sqlitedb"
    parser = optparse.OptionParser(usage=usage)

    parser.add_option("--maxtime", metavar="CUTOFF",
                      dest="maxtime", default=20, type=int,
                      help="Max time for an operation")

    parser.add_option("--maxmemory", metavar="CUTOFF",
                      dest="maxmemory", default=500, type=int,
                      help="Max memory for a subsystem")

    parser.add_option("--minmemory", metavar="MINMEM",
                      dest="minmemory", default=100, type=int,
                      help="Minimum memory to be checked for RSS vs counted check")

    parser.add_option("--verbose", "-v", action="store_true", default=False,
                      dest="verbose", help="Print more output")

    parser.add_option("--lines", "-l", default=15, type=int,
                      dest="max_lines", help="Only print top N lines")


    (options, args) = parser.parse_args()

    if len(args) != 2:
        print("ERROR: You must give a lemma file and an SQL file")
        exit(-1)

    lemmafname = args[0]
    dbfname = args[1]
    print("Using sqlite3db file %s" % dbfname)
    print("Using lemma file %s" % lemmafname)

    useful_lemmas = parse_lemmas(lemmafname)

    with Query() as q:
        q.add_goods(useful_lemmas)
        for stat in ["glue", "size", "num_overlap_literals",
                     "avg_vsids_score", "antecedents_avg_glue_long_reds",
                     "avg_vsids_of_resolving_literals",
                     "conflicts_this_restart"]:
            print("--->>> %s <<--------" % stat)
            q.find_goods(stat)
            q.find_bads(stat)




