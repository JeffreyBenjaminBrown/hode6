# exec ( open ( "src/demo/typedb.py" ) . read () )

import typedb
from typedb.driver import TypeDB, SessionType, TransactionType

from src.util.typedb import *


DB_NAME = "demo"
SERVER_ADDR = "127.0.0.1:1729"

delete_db_if_present (DB_NAME)
create_db_if_absent (DB_NAME)

schema_define (
  db = DB_NAME,
  defs = [ "define person sub entity;",
           " ".join ( [ "define name sub attribute,"
                        "value string;"
                        "person owns name;" ] ) ] )

data_insert (
  db = DB_NAME,
  defs = [ "insert $p isa person, has name 'Alice';",
           "insert $p isa person, has name 'Bob';" ] )

json = data_fetch ( # TODO: Fix definition of data_fetch.
  db = DB_NAME,
  query = "match $p isa person; fetch $p: name;" )
