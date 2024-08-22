# exec ( open ( "src/demo/hode_data.py" ) . read () )
# For some useful boilerplate see src/demo/typedb.py.

import typedb
from   typedb.driver import TypeDB, SessionType, TransactionType
from   typedb.concept.answer.concept_map import _ConceptMap
from   typing import Dict, List, Set

from   src.util.random_uid import random_uid
import src.util.typedb as tdb


DB_NAME = "hode"

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
