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

echo "Tagging images"
docker tag $docker_repository/rvss-backend $docker_registry/$gc_project/rvss-backend:latest
docker tag $docker_repository/rvss-server-sync $docker_registry/$gc_project/rvss-server-sync:latest
docker tag $docker_repository/rvss-server-async $docker_registry/$gc_project/rvss-server-async:latest
docker tag $docker_repository/rvss-jmeter $docker_registry/$gc_project/rvss-jmeter:latest

if [ $? -ne 0 ]
then
  echo "Tagging error...exiting."
  exit $?
fi

echo "Pushing images"
docker push $docker_registry/$gc_project/rvss-backend:latest
docker push $docker_registry/$gc_project/rvss-server-sync:latest
docker push $docker_registry/$gc_project/rvss-server-async:latest
docker push $docker_registry/$gc_project/rvss-jmeter:latest

if [ $? -ne 0 ]
then
  echo "Pushing images error...exiting."
  exit $?
fi
