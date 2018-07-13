#!/bin/bash
usage="$(basename "$0") [-c CLUSTER-NAME] [-z ZONE] [-h]

Creates the deployments for JMeter

where:
    -c  set the CLUSTER-NAME (default: jmeter)
    -z  set the ZONE (default: us-central1-a)
    -h  show this help text"

cluster_name=jmeter
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

echo "Getting auth for the jmeter cluster"
gcloud container clusters get-credentials jmeter

echo "Creating volume for synchronous server"
gcloud compute disks create --size=1GB --zone=$zone jmeter-sync-volume

echo "Creating JMeter for the synchronous server"
cat kubernetes/jmeter/jmeter-sync.yml | sed "s/%%SERVER_HOST%%/$SERVER_SYNC_IP/" | kubectl create -f -

echo "Creating volume for reactive server"
gcloud compute disks create --size=1GB --zone=$zone jmeter-async-volume

echo "Creating JMeter for the reactive server"
cat kubernetes/jmeter/jmeter-async.yml | sed "s/%%SERVER_HOST%%/$SERVER_ASYNC_IP/" | kubectl create -f -
