# exec ( open ( "src/demo/typedb.py" ) . read () )

import typedb
from   typedb.driver import TypeDB, SessionType, TransactionType
from   typedb.concept.answer.concept_map import _ConceptMap
from   typing import Dict, List, Set

from src.util.typedb import *


DB_NAME = "demo"

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

attributes : Dict = data_fetch (
  db = DB_NAME,
  query = "match $p isa person; fetch $p: name;" )

concepts : List [ _ConceptMap ] = data_get (
  db    = DB_NAME,
  query = "match $p isa person; get $p;" )

# DEPRECATED. TypeDB (the company) say roll your own instead,
# because so far the iid ("internal id") is mutable.
iids : List [iid] = data_get_iids (
  db = DB_NAME,
  query = "match $p isa person; get $p;" )
