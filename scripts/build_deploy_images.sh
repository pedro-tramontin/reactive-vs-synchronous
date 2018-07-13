#!/bin/bash

usage="$(basename "$0") [-d DIR] [-h]

Builds, tags and push the docker images to Google Registry

where:
    -d  set the project root directory (default: .)
    -h  show this help text"

dir=.

while getopts ':hd:' option; do
  case "$option" in
    d) dir=$OPTARG
       ;;
    h|*) echo "$usage"
       exit
       ;;
  esac
done
shift "$((OPTIND - 1))"

echo "Setting working dir to $dir"
cd $dir

echo "Loading env variables"
source scripts/config.sh

echo "Calling gradle to build images"
./gradlew docker

if [ $? -ne 0 ]
then
  echo "Build error...exiting."
  exit $?
fi

repo="$docker_repository"
gcr="$docker_registry/$gc_project"

echo "Tagging images"
docker tag $repo/rvss-backend $gcr/rvss-backend:latest
docker tag $repo/rvss-server-sync $gcr/rvss-server-sync:latest
docker tag $repo/rvss-server-async $gcr/rvss-server-async:latest
docker tag $repo/rvss-jmeter $gcr/rvss-jmeter:latest

if [ $? -ne 0 ]
then
  echo "Tagging error...exiting."
  exit $?
fi

echo "Pushing images"
docker push $gcr/rvss-backend:latest
docker push $gcr/rvss-server-sync:latest
docker push $gcr/rvss-server-async:latest
docker push $gcr/rvss-jmeter:latest

if [ $? -ne 0 ]
then
  echo "Pushing images error...exiting."
  exit $?
fi

source scripts/kubernetes_sync.sh

source scripts/check_endpoint.sh server-sync

export SERVER_SYNC_IP=$external_ip

echo "Sync server external IP: $SERVER_SYNC_IP"

source scripts/kubernetes_async.sh

source scripts/check_endpoint.sh server-async

export SERVER_ASYNC_IP=$external_ip

echo "Reactive server external IP: $SERVER_ASYNC_IP"

source scripts/kubernetes_jmeter.sh
