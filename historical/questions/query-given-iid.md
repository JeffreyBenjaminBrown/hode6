I recently asked, in the thread here:
```
https://forum.typedb.com/t/how-to-get-the-unique-identifier-of-a-thing-in-the-graph/554/8
```
"How to get the unique identifier of a thing in the graph?" Now I have the inverse question: Given the `iid` of something in the graph, how can you query to retrieve that thing?

I understand that (although I don't understand why) `iid` is not a normal attribute, and cannot be queried like the others. But `get` and `fetch` seem like the only methods remotely suited to the task. Both of the following queries (using the Python driver) elicit a `no viable alternative` error at the word `iid`. I imagine that means "No (ordinary) attribute called `iid` belongs to the class `person`.

```
data_get ( db = DB_NAME, query = "match $p isa person, has iid '0x826e80018000000000000000'; get $p;" )

data_fetch ( db = DB_NAME, query = "match $p isa person, has iid '0x826e80018000000000000000'; fetch $p: iid;" )
```

I've put the definitions of `data_get` and `data_fetch` at the end of this post. Aside from the list comprehension trick, they're straight from the TypeDB QuickStart code.

I've reread the documentation on `fetch`, `get`, and `concept`s. None of the `pattern`s seem relevant, nor do any of the `statement`s (`is` gave me hope, but no dice). And yet there must be a way to do this, right?

If there isn't, of course, I can just generate my own attribute, parallel to and unique like `iid`, but queriable in the ordinary way. But it would be embarrassingly inelegant.

```
def data_fetch (
    db : str,
    query : str
) -> ( Dict # Recursive JSON, whose type can't be specified
       # completely -- e.g. its depth depends on the query.
      ):
  with TypeDB.core_driver (
      SERVER_ADDR ) as driver:
    with driver.session ( db,
                          SessionType . DATA ) as session:
      with session.transaction (
          TransactionType.READ ) as tx:
        return [ # The fetch object is an iterator
          # that becomes useless when the session ends.
          # This list comprehension
          # lets me smuggle the results outside the function.
          r for r in tx.query.fetch ( query ) ]

def data_get (
    db : str,
    query : str
) -> List [ # todo: Why are these `_ConceptMap`s, and how do
            # those differ from `ConceptMap`s (without "_")?
  _ConceptMap ]:
  with TypeDB.core_driver (
      SERVER_ADDR ) as driver:
    with driver.session ( db,
                          SessionType . DATA ) as session:
      with session.transaction (
          TransactionType.READ ) as tx:
        return [ # The get object is an iterator
          # that becomes useless when the session ends.
          # This list comprehension
          # lets me smuggle the results outside the function.
          r for r in tx.query.get ( query ) ]
```
