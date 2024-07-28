# TODO:
# This doesn't work as of today 2024-06-27,
# due to a Python client - TypeDB server mismatch.
#
# ORIGIN:
# This is from TypeDB's Python client QuickStart:
#   https://typedb.com/docs/drivers/python/overview
# I had to replace every instance of "driver" with "client".

import typedb
from typedb.client import TypeDB, SessionType, TransactionType

DB_NAME = "access-management-db"
SERVER_ADDR = "127.0.0.1:1729"

with TypeDB.core_client(SERVER_ADDR) as client:
  if client.databases.contains(DB_NAME):
    client.databases.get(DB_NAME).delete()
  client.databases.create(DB_NAME)

  with client.session (
      DB_NAME,
      SessionType.SCHEMA ) as session:
    with session.transaction (
        TransactionType.WRITE ) as tx:
      tx.query.define( "define person sub entity;" )
      tx.query.define(" ".join (
        [ "define name sub attribute, value string;"
          "person owns name;" ] ) )
      tx.commit ()

  with client.session(
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
      for json in results:
        print (json)
