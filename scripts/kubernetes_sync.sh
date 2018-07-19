#!/bin/bash

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

basedir=$(dirname -- "$0")

echo "Loading env variables"
source ${basedir}/config.sh
source ${basedir}/utils.sh

echo "Getting auth for the sync cluster"
gcloud container clusters get-credentials ${container_sync}

if [ $? -ne 0 ]
then
  echo "Error getting auth...exiting."
  exit $?
fi

echo "Creating synchronous backend"
kubectl create -f ${basedir}/../kubernetes/sync/deployment-backend.yml

if [ $? -ne 0 ]
then
  echo "Error creating synchronous backend...exiting."
  exit $?
fi

echo "Creating service for the synchronous backend"
kubectl create -f ${basedir}/../kubernetes/sync/service-backend.yml

if [ $? -ne 0 ]
then
  echo "Error creating service...exiting."
  exit $?
fi

echo "Creating synchronous server"
kubectl create -f ${basedir}/../kubernetes/sync/deployment-server.yml

if [ $? -ne 0 ]
then
  echo "Error creating synchronous server...exiting."
  exit $?
fi

echo "Creating service for the synchronous server"
kubectl create -f ${basedir}/../kubernetes/sync/service-server.yml

if [ $? -ne 0 ]
then
  echo "Error creating service...exiting."
  exit $?
fi

get_service_external_ip server-sync SERVER_SYNC_IP

echo "Sync server external IP: $SERVER_SYNC_IP"
