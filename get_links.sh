#!/bin/bash
#########################################################################################
# List all Branchs

printf "\n"

for image in $(docker inspect --format='{{.Config.Image}}___________{{.Name}}' $(sudo docker ps -aq --no-trunc)); do

 if [ "${image/mongo}" = "$image" ]; then
   echo "http://public_ip:${image/application-}"
 fi

done

printf "\n"
