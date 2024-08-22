import typedb
from   typedb.driver import TypeDB, SessionType, TransactionType
from   typedb.concept.answer.concept_map import _ConceptMap
from   typing import Dict, List, Set

from   src.util.random_uid import random_uid
import src.util.typedb as tdb
import src.util.hode_data as hd


def create_hode_db_destructive ():
  """Obliterate any previously existing DB named 'hode', and make a new one with the data described here."""
  tdb.delete_db_if_present (hd.DB_NAME)
  tdb.create_db_if_absent (hd.DB_NAME)

  tdb . schema_define (
    db = hd.DB_NAME,
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

  # Make some notes and save their UIDs
  a   = hd.insert_note ("a")
  aa  = hd.insert_note ("aa")
  ab  = hd.insert_note ("ab")
  aba = hd.insert_note ("aba")
  abb = hd.insert_note ("abb")
  b   = hd.insert_note ("b")
  ba  = hd.insert_note ("ba")
  bb  = hd.insert_note ("bb")

  for source, target in [ (a, aa),
                          (a, ab),
                          (ab, aba),
                          (ab, abb),
                          (b, ba),
                          (b, bb) ]:
    hd.insert_arrow ( source = source,
                      target = target )
