docker run --name hode -it -d                     \
  -v typedb-data:/opt/                            \
  -v /home/jeff/hodal/hode6/config:/mnt/config:ro \
  -v /home/jeff/hodal/hode6/python:/mnt/python:ro \
  -v /home/jeff/hodal/hode6/hode-data:/mnt/write  \
  -p 1729:1729                                    \
  --platform linux/amd64                          \
  jeffreybbrown/hode:latest
