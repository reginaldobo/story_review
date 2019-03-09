#!/bin/bash
###########################################################
# Deploy branch 

if [ $(docker ps | wc -l) -ge 7 ]; then
  echo "Too many Containers. Remove some and try again."
  exit 0
fi

echo Deploying $1

cd /home/ubuntu

BRANCH=$(echo $1 | cut -d/ -f2)

mkdir $BRANCH

cp base/settings.json $BRANCH

cp base/Dockerfile $BRANCH

cd $BRANCH

PORTA=$(shuf -i 50000-60000 -n 1)
ex -sc "%s/{{deploy}}/SR/g" -cx settings.json
ex -sc "%s/{{hostname}}/Teste-SR/g" -cx settings.json
ex -sc "%s/{{PORT}}/$PORTA/g" -cx settings.json

# clone repository
git clone -b $1 git@github.com:app/meteor-app.git

# build app
cd meteor-app
PATH=$PATH:/home/ubuntu/.nvm/versions/node/v4.4.7/bin
demeteorizer -o ..
cd ..

# build docker
cp Dockerfile bundle
cd bundle
docker build -t app-$PORTA .
cd ..
cat settings.json

# run docker
docker run -d --name $BRANCH --network="host" -e METEOR_SETTINGS="$(cat settings.json)" -e PORT=$PORTA -e MONGO_URL=mongodb://localhost:27017/meteor -e ROOT_URL=https://localhost:$PORTA -t -i -p 80:$PORTA app-$PORTA
timeout 55 docker logs -f $BRANCH
URL='http://'$(curl http://169.254.169.254/latest/meta-data/public-ipv4)':'$PORTA
echo $1'  ->  '$URL

# clean
cd ..
rm -rf $BRANCH

exit 0
