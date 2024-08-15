docker run --name hode -it -d         \
  -v typedb-data:/opt/                \
  -v $host_root/config:/mnt/config:ro \
  -v $host_root/src:/mnt/src:ro       \
  -v $host_root/hode-data:/mnt/write  \
  -p 1729:1729                        \
  --platform linux/amd64              \
  jeffreybbrown/hode:new
