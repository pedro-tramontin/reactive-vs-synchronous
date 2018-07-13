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

echo "Creating JMeter for the synchronous server"
kubectl create -f ../kubernetes/jmeter/jmeter-sync.yml

echo "Creating JMeter for the reactive server"
kubectl create -f ../kubernetes/jmeter/jmeter-async.yml
