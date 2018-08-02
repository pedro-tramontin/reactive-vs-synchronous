#!/bin/bash

basedir=$(dirname -- "$0")

source ${basedir}/utils.sh


usage="$(basename "$0") [-c CLUSTER-NAME] [-z ZONE] [-h]

Creates the deployments and services to run the synchronous server.

where:
    -c  set the CLUSTER-NAME (default: sync)
    -z  set the ZONE (default: us-central1-a)
    -h  show this help text"

cluster_name=sync
zone=us-central1-a

while getopts ':hc:z:' option; do
  case "$option" in
    c) cluster_name=$OPTARG
       ;;
    z) zone=$OPTARG
       ;;
    h|*) echo "$usage"
       exit
       ;;
  esac
done
shift "$((OPTIND - 1))"


echo "Loading env variables"
source ${basedir}/config.sh


has_sync_container=$(gcloud container clusters list --zone=${zone} --format="get(name)" \
  --filter="name=${container_sync}")
if [ -z "${has_sync_container}" ]
then
  echo "Sync container doesn't exists...exiting."

  exit 1
fi


echo "Getting auth for the sync cluster"
gcloud container clusters get-credentials ${container_sync} --zone=${zone}

message_if_error "Error getting auth...exiting."


has_dep_back_sync=$(kubectl get deployments --field-selector='metadata.name=${app_backend_sync}' \
  -o jsonpath='{.items[*].metadata.name}')
if [ -z "${has_dep_back_sync}" ]
then
  echo "Creating synchronous backend deployment"
  cat ${basedir}/../kubernetes/deployment/backend.yml | \
    sed "s/%%APP_BACKEND%%/${app_backend_sync}/" | \
    sed "s#%%IMAGE_PREFIX%%#${image_prefix}#" | \
    sed "s/%%IMAGE_NAME%%/${project_backend}/" | \
    sed "s/%%IMAGE_TAG%%/${docker_tag}/" | \
    kubectl create -f -

  message_if_error  "Error creating synchronous backend...exiting."
else
  echo "Synchronous backend deployment already exists."
fi


has_dep_svc_back_sync=$(kubectl get services --field-selector='metadata.name=${app_backend_sync}' \
  -o jsonpath='{.items[*].metadata.name}')
if [ -z "${has_dep_svc_back_sync}" ]
then
  echo "Creating service for synchronous backend"
  cat ${basedir}/../kubernetes/service/backend.yml | \
    sed "s/%%APP_BACKEND%%/${app_backend_sync}/" | \
    kubectl create -f -

  message_if_error  "Error creating service...exiting."
else
  echo "Service for synchronous backend already exists"
fi


has_dep_server_sync=$(kubectl get deployments --field-selector='metadata.name=${app_server_sync}' \
  -o jsonpath='{.items[*].metadata.name}')
if [ -z "${has_dep_server_sync}" ]
then
  echo "Creating synchronous server deployment"
  cat ${basedir}/../kubernetes/deployment/server.yml | \
    sed "s/%%APP_SERVER%%/${app_server_sync}/" | \
    sed "s/%%APP_BACKEND%%/${app_backend_sync}/" | \
    sed "s#%%IMAGE_PREFIX%%#${image_prefix}#" | \
    sed "s/%%IMAGE_NAME%%/${project_sync}/" | \
    sed "s/%%IMAGE_TAG%%/${docker_tag}/" | \
    kubectl create -f -

  message_if_error  "Error creating synchronous server...exiting."
else
  echo "Synchronous server deployment already exists."
fi


has_dep_svc_server_sync=$(kubectl get services --field-selector='metadata.name=${app_server_sync}' \
  -o jsonpath='{.items[*].metadata.name}')
if [ -z "${has_dep_svc_server_sync}" ]
then
  echo "Creating service for the synchronous server"
  cat ${basedir}/../kubernetes/service/server.yml | \
    sed "s/%%APP_SERVER%%/${app_server_sync}/" | \
    kubectl create -f -

  message_if_error  "Error creating service...exiting."
else
  echo "Service for the synchronous server already exists."
fi


get_service_external_ip server-sync SERVER_SYNC_IP

echo "Sync server external IP: ${SERVER_SYNC_IP}"

