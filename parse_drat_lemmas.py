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

    def get_names(self):
        names = None
        for row in self.c.execute("select * from clauseStats limit 1"):
            names = list(map(lambda x: x[0], self.c.description))
        return names

    def get_all(self):
        goods = []

        q = """
        SELECT clauseStats.*
        FROM clauseStats, goodClauses
        WHERE clauseStats.clauseID = goodClauses.clauseID
        and clauseStats.runID = goodClauses.runID
        and clauseStats.runID = {0}
        """.format(self.runID)
        for row in self.c.execute(q):
            r = list(row)
            r.append(1)
            goods.append(r)

        bads = []
        q = """
        SELECT clauseStats.*
        FROM clauseStats left join goodClauses
        on clauseStats.clauseID = goodClauses.clauseID
        and clauseStats.runID = goodClauses.runID
        where goodClauses.clauseID is NULL
        and goodClauses.runID is NULL
        and clauseStats.runID = {0}
        """.format(self.runID)
        for row in self.c.execute(q):
            r = list(row)
            r.append(0)
            bads.append(r)

        return goods, bads


if __name__ == "__main__":

    usage = "usage: %prog [options] lemma_file sqlitedb"
    parser = optparse.OptionParser(usage=usage)

    parser.add_option("--verbose", "-v", action="store_true", default=False,
                      dest="verbose", help="Print more output")

    (options, args) = parser.parse_args()

    if len(args) != 2:
        print("ERROR: You must give a lemma file and an SQL file")
        exit(-1)

    lemmafname = args[0]
    dbfname = args[1]
    print("Using sqlite3db file %s" % dbfname)
    print("Using lemma file %s" % lemmafname)

    useful_lemma_ids = parse_lemmas(lemmafname)

    with Query() as q:
        names = q.get_names()
        names.append("class")
        print("column names: ", names)

        q.add_goods(useful_lemma_ids)
        goods, bads = q.get_all()
        print("--- good examples:")
        for row in goods[:20]:
            print(row)

        print("--- bad examples:")
        for row in bads[:20]:
            print(row)
