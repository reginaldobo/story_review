#!/bin/bash
#########################################################################
# Restore last backup

echo 'Creating tmp dir'

rm -rf /tmp/app

mkdir /tmp/app

echo 'Geting last Backup file name'

FILE=`aws s3 ls s3://app-backup-hourly/db-prod/  | sort | tail -n 1 | awk '{print $4}'`

echo 'Coping file from S3 to tmp:' $FILE

aws s3 cp s3://app-backup-hourly/db-prod/$FILE /tmp/app/$FILE

echo 'Unziping file' $FILE

tar -xvzf /tmp/app/$FILE -C /tmp/app

echo 'Droping current Database'

mongo meteor -port 27017 --eval 'db.dropDatabase()'

echo 'Restoring database' $FILE

mongorestore --port 27017 -d meteor /tmp/app/${FILE//.tgz}/app_production

echo 'Deleting tmp folder'

rm -rf /tmp/app

echo 'Successfuly restored!'
