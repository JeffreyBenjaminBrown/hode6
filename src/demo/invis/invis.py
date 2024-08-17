# import src.demo.invis.invis
# exec ( open ( "src/demo/invis/invis.py" ) . read () )

from typing import Dict, List, Tuple
from dataclasses import dataclass

from src.util.random_uid import random_uid


with open("data/hide-start-symbol.txt", 'r') as file:
    hide_start_symbol = file.read () . strip()
with open("data/hide-stop-symbol.txt", 'r') as file:
    hide_stop_symbol  = file.read () . strip()
viewfile_path = "/mnt/write/view.hode"

instructional_header = \
"""Welcome to the hiddent text demo.
See the README for what to do."""

uid = str

@dataclass
class Document: # Basically a list of (UID, int) pairs.
  order : List [uid]     # Each node has an invisible ID.
  data  : Dict [uid,int] # Each node has a visible int.

the_document = Document ( order = [],
                          data = {} )

def document_to_list ( doc : Document
                      ) -> List [ Tuple [uid, int ] ]:
  return [ ( id,
             doc.data[id] )
           for id in doc.order ]

def document_to_string ( doc : Document
                        ) -> str:
  return "\n".join (
    [ instructional_header] +
    [ hide_start_symbol + uid + hide_stop_symbol
      + str ( n )
      for uid,n in
      document_to_list ( doc ) ] )

def write_viewfile ():
  with open ( viewfile_path, "w") as viewfile:
    viewfile . write (
      document_to_string ( the_document ) )

def insert_node ():
  uid = random_uid ()
  the_document.order.append ( uid )
  the_document.data.update ( { uid : 0 } )
  write_viewfile ()

def increment_node (uid):
  n = the_document . data [uid]
  the_document . data . update ( { uid : n+1 } )
  write_viewfile ()
