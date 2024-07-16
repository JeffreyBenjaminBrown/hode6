import typedb_driver_python.typedb.client as td
  # TypeDB, SessionType, TransactionType,
  # TypeDBOptions, TypeDBCredential
from enum import Enum


DB_NAME = "sample_app_db"
SERVER_ADDR = "127.0.0.1:1729"

class Edition(Enum):
    Cloud = 1
    Core  = 2

TYPEDB_EDITION = Edition.Core
CLOUD_USERNAME = "admin"
CLOUD_PASSWORD = "password"


def main():
  with td.connect_to_TypeDB ( TYPEDB_EDITION,
                              SERVER_ADDR ) as driver:
    if td.db_setup ( driver,
                     DB_NAME,
                     db_reset = False):
      td.queries ( driver, DB_NAME )
    else:
      print("Terminating...")
      exit()
