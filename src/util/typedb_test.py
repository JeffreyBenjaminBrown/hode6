# PYTHONPATH=$PYTHONPATH:. pytest src/util/typedb_test.py

from src.util.typedb import *
from src.util.random_uid import random_uid


def test_make_and_delete_db ():
  name = "temporary_garbage_for_testing"
  create_db_if_absent (name)
  with TypeDB.core_driver (SERVER_ADDR) as driver:
    assert     driver.databases.contains (name)
  delete_db_if_present (name)
  with TypeDB.core_driver (SERVER_ADDR) as driver:
    assert not driver.databases.contains (name)
