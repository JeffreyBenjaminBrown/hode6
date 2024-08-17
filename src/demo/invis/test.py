# source /home/user/.venv/bin/activate
# PYTHONPATH=$PYTHONPATH:. pytest src/demo/invis/test.py
from src.demo.invis.invis import *

def test_document_to_list ():
  assert (
    document_to_list (
      Document ( order = ["b","a"],
                 data = { "a" : 1,
                          "b" : 2 } ) )
    == [ ("b",2),
         ("a",1) ] )
