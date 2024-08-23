# USAGE:
# See either of
#   src/demo/typedb.py
#   src/util/hode_data.py
# (Some of these functions are only used in one of those.)

# PITFALL: Multiple sessions are inefficient.
#
# The idiom used here lends itself to inefficient coding.
# I create a new core_driver instance,
# and from it a new session,
# in most of the functions defined below.
# Calling a whole lot of those functions at once
# will surely be much less efficient than collecting the operations
# into a single session.
#
# One solution would be to leave the session open,
# but then I would have to worry about closing it once I'm done,
# which so far seems unworth the extra thought.
#
# A middle path, which I like, is to batch all similar operations
# (for instance, all schema definition operations)
# into a single function call. These functions permit that.

# FURTHER GUIDANCE:
#
# There are a few comments in `src/demo/typedb.py`,
# regarding uniqueness constraints
# and alternative ways of doing things,
# which I thought would be helpful and are not reproduced here.

import typedb
from   typedb.concept.answer.concept_map import _ConceptMap
from   typedb.driver import TypeDB, SessionType, TransactionType
from   typing import Dict, List, Set


iid = str

SERVER_ADDR = "127.0.0.1:1729"

def delete_db_if_present ( db : str ):
  with TypeDB.core_driver (SERVER_ADDR) as driver:
    if driver.databases.contains (db):
      driver.databases.get (db) . delete ()

def create_db_if_absent ( db : str ):
  with TypeDB.core_driver(SERVER_ADDR) as driver:
    if not driver.databases.contains(db):
      driver.databases.create(db)

def schema_define ( db : str,
                    defs : List [str] ):
  with TypeDB.core_driver (SERVER_ADDR) as driver:
    with driver.session ( db,
                          SessionType.SCHEMA ) as session:
      with session.transaction ( TransactionType.WRITE
                                ) as tx:
        for d in defs:
          tx.query.define (d)
        tx.commit ()

def data_insert ( db : str,
                  defs : List [str] ):
  with TypeDB.core_driver( SERVER_ADDR
                          ) as driver:
    with driver.session( db,
                         SessionType . DATA ) as session:
      with session.transaction ( TransactionType.WRITE
                                ) as tx:
        for d in defs:
          tx.query.insert (d)
        tx.commit ()

def data_delete ( db : str,
                  query : List [str] ):
  with TypeDB.core_driver( SERVER_ADDR
                          ) as driver:
    with driver.session( db,
                         SessionType . DATA ) as session:
      with session.transaction ( TransactionType.WRITE
                                ) as tx:
        tx.query.delete (query)
        tx.commit ()

def data_fetch (
    db : str,
    query : str
) -> ( Dict # Recursive JSON, whose type can't be specified
       # completely -- e.g. its depth depends on the query.
      ):
  with TypeDB.core_driver (
      SERVER_ADDR ) as driver:
    with driver.session ( db,
                          SessionType . DATA ) as session:
      with session.transaction (
          TransactionType.READ ) as tx:
        return [ # The query is an iterator that becomes useless
          # when the session ends. This list comprehension
          # lets me smuggle the results outside the function.
          r for r in tx.query.fetch ( query ) ]

def data_get (
    db : str,
    query : str
) -> List [ # todo: Why are these `_ConceptMap`s, and how do
            # those differ from `ConceptMap`s (without "_")?
  _ConceptMap ]:
  with TypeDB.core_driver (
      SERVER_ADDR ) as driver:
    with driver.session ( db,
                          SessionType . DATA ) as session:
      with session.transaction (
          TransactionType.READ ) as tx:
        return [ # The query is an iterator that becomes useless
          # when the session ends. This list comprehension
          # lets me smuggle the results outside the function.
          r for r in tx.query.get ( query ) ]

def data_get_iids (
    db : str,
    query : str
) -> List [ iid ]:
  """DEPRECATED: The "iid" field in TypeDB is not static. They recommend rolling your own that is, if you want a UID."""
  return [ c.get_iid ()
           for g in data_get ( db = db,
                               query = query )
           for c in g.concepts () ]
