DOCKER_IMAGE_SUFFIX="2024-06-27.python"
STARTING_AT=$(date)
echo $(date)
docker build -t jeffreybbrown/hode:new .
echo $(date)

docker tag jeffreybbrown/hode:new jeffreybbrown/hode:latest
docker tag jeffreybbrown/hode:new jeffreybbrown/hode:$DOCKER_IMAGE_SUFFIX
docker rmi jeffreybbrown/hode:new

docker push jeffreybbrown/hode:$DOCKER_IMAGE_SUFFIX
docker push jeffreybbrown/hode:latest

docker stop hode && docker rm hode
