#!/bin/bash
usage="$(basename "$0") [-c CLUSTER-NAME] [-z ZONE] [-h]

Creates the deployments and services to run the reactive server.

where:
    -c  set the CLUSTER-NAME (default: async)
    -z  set the ZONE (default: us-central1-a)
    -h  show this help text"

cluster_name=async
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

echo "Getting auth for the async cluster"
gcloud container clusters get-credentials async

if [ $? -ne 0 ]
then
  echo "Error getting auth...exiting."
  exit $?
fi

echo "Creating reactive backend"
kubectl create -f kubernetes/async/deployment-backend.yml

if [ $? -ne 0 ]
then
  echo "Error creating reactive backend...exiting."
  exit $?
fi

echo "Creating service for the reactive backend"
kubectl create -f kubernetes/async/service-backend.yml

if [ $? -ne 0 ]
then
  echo "Error creating service...exiting."
  exit $?
fi

echo "Creating reactive server"
kubectl create -f kubernetes/async/deployment-server.yml

if [ $? -ne 0 ]
then
  echo "Error creating reactive server...exiting."
  exit $?
fi

echo "Creating service for the reactive server"
kubectl create -f kubernetes/async/service-server.yml

if [ $? -ne 0 ]
then
  echo "Error creating service...exiting."
  exit $?
fi

source scripts/check_endpoint.sh

get_service_external_ip server-async SERVER_ASYNC_IP

echo "Reactive server external IP: $SERVER_ASYNC_IP"
