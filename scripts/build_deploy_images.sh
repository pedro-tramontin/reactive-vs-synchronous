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
docker tag ${docker_repository}/${project_backend} ${image_prefix}/${project_backend}:${docker_tag}
docker tag ${docker_repository}/${project_sync} ${image_prefix}/${project_sync}:${docker_tag}
docker tag ${docker_repository}/${project_async} ${image_prefix}/${project_async}:${docker_tag}
docker tag ${docker_repository}/${project_jmeter} ${image_prefix}/${project_jmeter}:${docker_tag}

message_if_error "Tagging error...exiting."


echo "Pushing images"
docker push ${image_prefix}/${project_backend}:${docker_tag}
docker push ${image_prefix}/${project_sync}:${docker_tag}
docker push ${image_prefix}/${project_async}:${docker_tag}
docker push ${image_prefix}/${project_jmeter}:${docker_tag}

message_if_error "Pushing images error...exiting."
