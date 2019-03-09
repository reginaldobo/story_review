#!/bin/bash
###########################################################
# Remove Branch

echo Removing $1

cd /home/ubuntu

BRANCH=$(echo $1 | cut -d/ -f2)

IMAGE=$(docker ps -a | grep $BRANCH | awk '{print $2}')

docker stop $BRANCH

docker rm $BRANCH

docker rmi $IMAGE

#docker volume rm $(docker volume ls -qf dangling=true)

exit 0
