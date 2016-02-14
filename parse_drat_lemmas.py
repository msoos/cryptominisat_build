#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import sqlite3
import optparse
import operator
import numpy
import time
from sklearn.preprocessing import StandardScaler
from sklearn.cross_validation import train_test_split
import functools

from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier


def mypow(to, base):
    return base**to


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

    def get_max_clauseID(self):
        q = """
        SELECT max(clauseID)
        FROM clauseStats
        WHERE runID = %d
        """ % self.runID

        max_clID = None
        for row in self.c.execute(q):
            max_clID = int(row[0])

        return max_clID

    def get_clausestats_names(self):
        names = None
        for row in self.c.execute("select * from clauseStats limit 1"):
            names = list(map(lambda x: x[0], self.c.description))
        return names

    def get_restarts(self):
        q = """
        select
            restart.restarts,
            numgood.cnt,
            restart.clauseIDendExclusive-restart.clauseIDstartInclusive as total
        from
            restart,
            (SELECT clauseStats.restarts as restarts, count(clauseStats.clauseID) as cnt
            FROM ClauseStats, goodClauses
            WHERE clauseStats.clauseID = goodClauses.clauseID
            and clauseStats.runID = goodClauses.runID
            and clauseStats.runID = {0}
            group by clauseStats.restarts) as numgood
        where
            restart.runID = {0}
            and restart.restarts = numgood.restarts
        """.format(self.runID)

        for row in self.c.execute(q):
            r = list(row)
            rest = r[0]
            good = r[1]
            total = r[2]
            print("rest num %-6d  conflicts %-6d good %-3.2f%%" %
                  (rest, total, float(good)/total*100.0))

    def get_all(self):
        ret = []

        q = """
        SELECT clauseStats.*
        FROM clauseStats, goodClauses
        WHERE clauseStats.clauseID = goodClauses.clauseID
        and clauseStats.runID = goodClauses.runID
        and clauseStats.runID = {0}
        order by RANDOM()
        """.format(self.runID)
        for row, _ in zip(self.c.execute(q), xrange(options.limit)):
            #first 5 are not useful, such as restarts and clauseID
            r = list(row[5:])
            ret.append([r, 1])

        bads = []
        q = """
        SELECT clauseStats.*
        FROM clauseStats left join goodClauses
        on clauseStats.clauseID = goodClauses.clauseID
        and clauseStats.runID = goodClauses.runID
        where goodClauses.clauseID is NULL
        and goodClauses.runID is NULL
        and clauseStats.runID = {0}
        order by RANDOM()
        """.format(self.runID)
        for row, _ in zip(self.c.execute(q), xrange(options.limit)):
            #first 5 are not useful, such as restarts and clauseID
            r = list(row[5:])
            ret.append([r, 0])

        numpy.random.shuffle(ret)
        X = [x[0] for x in ret]
        y = [x[1] for x in ret]
        return X, y


def print_clausestats_column_names():
    names = q.get_clausestats_names()
    names.append("class")
    print("column names: ", names)

if __name__ == "__main__":

    usage = "usage: %prog [options] lemma_file sqlitedb"
    parser = optparse.OptionParser(usage=usage)

    parser.add_option("--verbose", "-v", action="store_true", default=False,
                      dest="verbose", help="Print more output")

    parser.add_option("--limit", "-l", default=10**9, type=int,
                      dest="limit", help="Max number of good/bad clauses")

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

        q.add_goods(useful_lemma_ids)

        print_clausestats_column_names()
        #q.get_restarts()

        X, y = q.get_all()
        print(type(X))
        print(type(y))
        assert len(X) == len(y)

        print("--- examples:", len(X))
        print(X[0])
        print(y[0])

        #adding squares to it
        #X = [a+map(functools.partial(mypow, 2), b) for a, b in zip(X, X)]
        print(X[0])
        print(len(X[0]))
        X = StandardScaler().fit_transform(X)

        print("Training....")
        t = time.time()
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.5)
        print("type(X_train):", type(X_train))
        print("type(y_train):", type(y_train))

        #clf = KNeighborsClassifier(5)
        clf = DecisionTreeClassifier(max_depth=6)
        clf.fit(X_train, y_train)
        print("Training finished. T: %-3.2f" % (time.time()-t))

        print("Calculating score....")
        t = time.time()
        score = clf.score(X_test[2000:], y_test[2000:])
        print("score: %s T: %-3.2f" % (score, (time.time()-t)))
        #print(clf.tree_)
        clf.get_params()

