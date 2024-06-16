Some TypeDB | Docker commands:
```

# Global root mode, with a local folder I can write to at /mnt.
# (The global data is at /var/lib/docker/volumes/typedb-data,
# which somehow can just be called "typedb-data" here.)
docker run                               \
  --name typedb                          \
  -d                                     \
  -v typedb-data:/opt/                   \
  -v /home/jeff/hode3/mytypedb-data:/mnt \
  -p 1729:1729                           \
  --platform linux/amd64                 \
  vaticle/typedb:latest

# Local mode. DOES NOT WORK.
# Docker won't mount my own folder to the container's /opt.
docker run                              \
  --name typedb                         \
  -d                                    \
  -v /home/jeff/hode3/typedb-data:/opt/ \
  -p 1729:1729                          \
  --platform linux/amd64                \
  vaticle/typedb:latest

# enter it
docker exec -it typedb bash

# kill it
docker stop typedb && docker rm typedb

```
