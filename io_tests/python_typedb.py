# USAGE:
#Start the Docker container, and in it, the server:
#
#```
#docker run --name hode -it -d          \
#    -v typedb-data:/opt/               \
#    -v /home/jeff/hode6/hode-data:/mnt \
#    -p 1729:1729                       \
#    --platform linux/amd64             \
#    jeffreybbrown/hode:new
#docker exec -it hode bash
#/opt/typedb-all-linux-x86_64/typedb server
#```
#
#Enter it again to open a Python shell:
#```
#docker exec -it hode bash
#source /root/.venv/bin/activate
#ipython
#```
#
#Paste this text into that.

# TODO:
# The "usage" section above should be slicker.
# I shouldn't need to open two views into the Docker container;
# I should be able to run the server in the background,
# load the virtualenv, and launch ipython
# all from a single entry point.

# ORIGIN:
# This is from TypeDB's Python driver QuickStart:
#   https://typedb.com/docs/drivers/python/overview
# I had to replace every instance of "driver" with "driver".

import typedb
from typedb.driver import TypeDB, SessionType, TransactionType

DB_NAME = "access-management-db"
SERVER_ADDR = "127.0.0.1:1729"

with TypeDB.core_driver(SERVER_ADDR) as driver:
  if driver.databases.contains(DB_NAME):
    driver.databases.get(DB_NAME).delete()
  driver.databases.create(DB_NAME)

  with driver.session (
      DB_NAME,
      SessionType.SCHEMA ) as session:
    with session.transaction (
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
      for json in results:
        print (json)
