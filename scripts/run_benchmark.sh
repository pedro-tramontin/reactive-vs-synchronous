#!/bin/bash

source scripts/build_deploy_images.sh

if [ $? -ne 0 ]
then
  echo "Error building and deploying images...exiting."
  exit $?
fi

source scripts/create_containers.sh

if [ $? -ne 0 ]
then
  echo "Error creating cluster...exiting."
  exit $?
fi


source scripts/kubernetes_sync.sh

if [ $? -ne 0 ]
then
  echo "Error creating synchronous servers...exiting."
  exit $?
fi

source scripts/kubernetes_async.sh

if [ $? -ne 0 ]
then
  echo "Error creating reactive servers...exiting."
  exit $?
fi

echo "Waiting for instances to settle"
for i in {60..10..10}
do
  echo -ne $i"s "\\r
  sleep 10s
done

source scripts/kubernetes_jmeter.sh
