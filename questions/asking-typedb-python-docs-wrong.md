I asked the TypeDB forum this question today (2024 06 27).

# ##########################
# ##########################

Hello,

I'm making one thread out of these two issues because they seem very related.

Everything described below I discovered by running tweaks of the QuickStart script[1] in an iPython shell from within the TypeDB docker container (called "vaticle/typedb", with image ID 0f332410e5cb, up to date according to DockerHub as of today).

# Some obsolete documentation

The first instruction at the Overview[1] of the Python driver is to run `pip install typedb-driver`. That package is no longer in PyPi, but `typedb-client` is, so I installed the latter.

The QuickStart goes on to suggest some code, starting with `from typedb.driver import TypeDB, SessionType, TransactionType`. That module does not exist, but `typedb.client` does, and those types are all available within it.

Once I replaced every instance of the string "driver" to "client" (the two important targets being the module `typedb.driver` and the object `TypeDB.core_driver`), I was able to execute the script -- which uncovered the second issue.

# Version mismatch

Running that QuickStart code resulted in an error, the money quote from which appears to be the following:
```
_InactiveRpcError: <_InactiveRpcError of RPC that terminated with:
        status = StatusCode.INTERNAL
        details = "[SRV26] Invalid Server Operation: A protocol version mismat
ch was detected. This server supports version '3' but the driver supports vers
ion '1'. Please use a compatible driver to connect.
```

[1] https://typedb.com/docs/drivers/python/overview
