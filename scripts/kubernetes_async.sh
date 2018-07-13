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

echo "Creating reactive backend"
kubectl create -f kubernetes/async/deployment-backend.yml

echo "Creating service for the reactive backend"
kubectl create -f kubernetes/async/service-backend.yml

echo "Creating reactive server"
kubectl create -f kubernetes/async/deployment-server.yml

echo "Creating service for the reactive server"
kubectl create -f kubernetes/async/service-server.yml
