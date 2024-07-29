docker run --name hode -it -d          \
    -v typedb-data:/opt/               \
    -v /home/jeff/hode6/hode-data:/mnt \
    -p 1729:1729                       \
    --platform linux/amd64             \
    jeffreybbrown/hode:new

docker exec -it hode bash

docker stop hode && docker rm hode

STARTING_AT=$(date)
echo $(date)
docker build -t jeffreybbrown/hode:new .
echo $(date)

DOCKER_IMAGE_SUFFIX="2024-06-28.ubuntu-23.10"
docker tag jeffreybbrown/hode:new jeffreybbrown/hode:latest
docker tag jeffreybbrown/hode:new jeffreybbrown/hode:$DOCKER_IMAGE_SUFFIX
docker rmi jeffreybbrown/hode:new

docker push jeffreybbrown/hode:$DOCKER_IMAGE_SUFFIX
docker push jeffreybbrown/hode:latest
