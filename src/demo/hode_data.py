# exec ( open ( "src/demo/hode_data.py" ) . read () )
# Based on src/demo/typedb.py.

import typedb
from   typedb.driver import TypeDB, SessionType, TransactionType
from   typedb.concept.answer.concept_map import _ConceptMap
from   typing import Dict, List, Set

from   src.util.random_uid import random_uid
import src.util.typedb as tdb


DB_NAME = "hode"

tdb.delete_db_if_present (DB_NAME)
tdb.create_db_if_absent (DB_NAME)

tdb . schema_define (
  db = DB_NAME,
  defs = [
    "define text sub attribute, value string; ",
    "define uid  sub attribute, value string; ",
    ( "define note sub entity, "
      + "owns text, owns uid @unique; " ),
    ( "define arrow sub relation, "
      + "owns uid @unique, "
      + "relates source, relates target; " ),
    ( "define note plays arrow:source, plays arrow:target;" )
  ] )

def insert_note ( text : str
                 ) -> ( str # The note's UID
                       ):
  uid = random_uid ()
  tdb . data_insert (
    db = DB_NAME,
    defs = [ # just one element in list
      " ".join ( [ "insert $n isa note,",
                   "has text '" + text + "',",
                   "has uid '" + uid + "';" ] ) ] )
  return uid

def insert_arrow ( source : str, # a UID
                   target : str  # a UID
                  ) -> ( str # The relation's UID
                        ):
  uid = random_uid ()
  tdb . data_insert (
    db = DB_NAME,
    defs =  [ # only one element in this list
      " ".join ( [
        "match $s isa note, has uid '" + source + "';"
        "      $t isa note, has uid '" + target + "';",
        "insert $a(source:$s,target:$t) isa arrow,",
        "has uid '" + uid + "';"
      ] ) ] )
  return uid

# Make some notes and save their UIDs
a   = insert_note ("a")
aa  = insert_note ("aa")
ab  = insert_note ("ab")
aba = insert_note ("aba")
abb = insert_note ("abb")
b   = insert_note ("b")
ba  = insert_note ("ba")
bb  = insert_note ("bb")

for source, target in [ (a, aa),
                        (a, ab),
                        (ab, aba),
                        (ab, abb),
                        (b, ba),
                        (b, bb) ]:
  insert_arrow ( source = source,
                 target = target )

tdb.data_fetch (
  db    = DB_NAME,
  query = " ".join ( [
    "match $s isa note, has uid '" + a + "';"
    "      $a(source:$s,target:$t) isa arrow;"
    "fetch $t:text;" ] ) )
