# exec ( open ( "src/demo/invis/invis.py" ) . read () )

from typing import Dict, List, Tuple
from dataclasses import dataclass


with open("data/hide-start-symbol.txt", 'r') as file:
    hide_start_symbol = file.read () . strip()
with open("data/hide-stop-symbol.txt", 'r') as file:
    hide_stop_symbol  = file.read () . strip()
viewfile_path = "/mnt/write/view.hode"

instructional_header = """"
Welcome to the hiddent text demo.
TODO: Add instructions.
"""

uid = str

@dataclass
class Document:
  order : List [uid]     # Each line's invisible ID.
  data  : Dict [uid,int] # Each line shows a visible int.

the_document = Document ( order = [],
                          data = {} )

def document_to_list ( d : Document
                      ) -> List [ Tuple [str, int ] ]:
  return [ ( id,
             d.data[id] )
           for id in d.order ]

def document_to_string ( d : Document
                        ) -> str:
  return "\n".join (
    [ instructional_header] +
    [ hide_start_symbol + uid + hide_stop_symbol
      + str ( n )
      for uid,n in
      document_to_list ( document ) ] )

def write_viewfile ():
  with open ( viewfile_path, "w") as viewfile:
    viewfile . write (
      document_to_string ( the_document ) )
