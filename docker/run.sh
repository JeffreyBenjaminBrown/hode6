docker run --name hode -it -d           \
  -v typedb-data:/opt/                  \
  -v $host_root/data:/mnt/data:ro       \
  -v $host_root/src:/mnt/src:ro         \
  -v $host_root/mutable-data:/mnt/write \
  -p 1729:1729                          \
  --platform linux/amd64                \
  jeffreybbrown/hode:latest
