# exec ( open ( "src/demo/typedb.py" ) . read () )

# ORIGIN:
# This is from TypeDB's Python driver QuickStart:
#   https://typedb.com/docs/drivers/python/overview

import typedb
from typedb.driver import TypeDB, SessionType, TransactionType


DB_NAME = "demo"
SERVER_ADDR = "127.0.0.1:1729"

with TypeDB.core_driver(SERVER_ADDR) as driver: # Can be manually closed (instead of using `with`), uisng `.close()`. PITFALL: There can be only one.

  if driver.databases.contains(DB_NAME):
    driver.databases.get(DB_NAME).delete()
  driver.databases.create(DB_NAME)

  with driver.session ( # Can be manually closed (instead of using `with`), uisng `.close()`. PITFALL: There can be only one.
      DB_NAME,
      SessionType.SCHEMA ) as session:
    with session.transaction ( # Can be manually closed (instead of using `with`), uisng `.close()`.
        TransactionType.WRITE ) as tx:
      tx.query.define( "define person sub entity;" )
      tx.query.define(" ".join (
        [ "define name sub attribute, value string;"
          "person owns name;" ] ) )
      tx.commit ()

  with driver.session(
      DB_NAME,
      SessionType . DATA) as session:
    with session.transaction ( TransactionType.WRITE ) as tx:
      tx.query.insert("insert $p isa person, has name 'Alice';")
      tx.query.insert("insert $p isa person, has name 'Bob';")
      tx.commit ()
    with session.transaction (
        TransactionType.READ ) as tx:
      results = tx.query.fetch (
        "match $p isa person; fetch $p: name;")
      # To get objects rather than parameters:
      # results = tx.query.get (
      #   "match $n isa person; get $p;" )
      for json in results:
        print (json)
