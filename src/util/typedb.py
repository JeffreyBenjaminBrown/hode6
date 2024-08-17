# There are a few comments in `src/demo/typedb.py`,
# regarding uniqueness constraints
# and alternative ways of doing things,
# which are not reproduced here.

import typedb
from typedb.driver import TypeDB, SessionType, TransactionType
from typing import List


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

def data_fetch ( db : str,
                 query : str ): # TODO: Return type?
  # TODO: Whatever this returns is's only available
  # during the sessino. It has to be captured as JSON
  # before the session ends -- i.e. in this very function --
  # in order to be used by calling code.
  with TypeDB.core_driver (
      SERVER_ADDR ) as driver:
    with driver.session ( db,
                          SessionType . DATA ) as session:
      with session.transaction (
          TransactionType.READ ) as tx:
        results = tx.query.fetch ( query )

        # Diagnostics.
        print(results)
        print(type(results))
        for r in results: print(r)
        return r

#def data_get ( db : str,
#               query : str ): # TODO: Return type?
# everything should be the same as in data_fetch,
# except the last line:
#      ...
#        return tx.query.get ( query )
