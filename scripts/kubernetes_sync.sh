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

echo "Getting auth for the sync cluster"
gcloud container clusters get-credentials sync

echo "Creating synchronous backend"
kubectl create -f ../kubernetes/sync/deployment-backend.yml

echo "Creating service for the synchronous backend"
kubectl create -f ../kubernetes/sync/service-backend.yml

echo "Creating synchronous server"
kubectl create -f ../kubernetes/sync/deployment-server.yml

echo "Creating service for the synchronous server"
kubectl create -f ../kubernetes/sync/service-server.yml
