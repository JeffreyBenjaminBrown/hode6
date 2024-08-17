# There are a few comments in `src/demo/typedb.py`,
# regarding uniqueness constraints
# and alternative ways of doing things,
# which are not reproduced here.

import typedb
from   typedb.concept.answer.concept_map import _ConceptMap
from   typedb.driver import TypeDB, SessionType, TransactionType
from   typing import Dict, List, Set


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
) -> List [ # TODO: Why are these `_ConceptMap`s, and how do
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


# TODO: Turn those Concepts into IDs:
#
# In [30]:
#     ...: get : List [ ConceptMap ] = data_get (
#     ...:   db = DB_NAME,
#     ...:   query = "match $p isa person; get $p;" )
#
# In [31]: g=get[0]
#
# In [32]: gcs = [gc for gc in g.concepts() ]
#
# In [33]: gc = gcs[0]
#
# In [35]: gc.get_iid()
# Out[35]: '0x826e80018000000000000000'
#
# In [36]: type ( gc.get_iid() )
# Out[36]: str
