#!/bin/bash

basedir=$(dirname -- "$0")

source ${basedir}/utils.sh


usage="$(basename "$0") [-h]

Builds, tags and push the docker images to Google Registry

where:
    -h  show this help text"

while getopts ':h' option; do
  case "$option" in
    h|*) echo "$usage"
       exit
       ;;
  esac
done
shift "$((OPTIND - 1))"

basedir=$(dirname -- "$0")

echo "Loading env variables"
source ${basedir}/config.sh


echo "Calling gradle to build images"
sh -c "cd ${basedir}/.. && ./gradlew docker"

message_if_error "Build error...exiting."


echo "Tagging images"
docker tag ${docker_repository}/${project_backend} ${tag_repo}/${project_backend}:${tag}
docker tag ${docker_repository}/${project_sync} ${tag_repo}/${project_sync}:${tag}
docker tag ${docker_repository}/${project_async} ${tag_repo}/${project_async}:${tag}
docker tag ${docker_repository}/${project_jmeter} ${tag_repo}/${project_jmeter}:${tag}

message_if_error "Tagging error...exiting."


echo "Pushing images"
docker push ${tag_repo}/${project_backend}:${tag}
docker push ${tag_repo}/${project_sync}:${tag}
docker push ${tag_repo}/${project_async}:${tag}
docker push ${tag_repo}/${project_jmeter}:${tag}

message_if_error "Pushing images error...exiting."
