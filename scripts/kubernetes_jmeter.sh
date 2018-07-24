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

basedir=$(dirname -- "$0")

echo "Loading env variables"
source ${basedir}/config.sh
source ${basedir}/utils.sh

echo "Getting auth for the jmeter cluster"
gcloud container clusters get-credentials ${container_jmeter}

if [ $? -ne 0 ]
then
  echo "Error getting auth...exiting."
  exit $?
fi

echo "Creating JMeter for the synchronous server"
cat ${basedir}/../kubernetes/jmeter/jmeter-sync.yml | sed "s/%%SERVER_HOST%%/$SERVER_SYNC_IP/" | kubectl create -f -

if [ $? -ne 0 ]
then
  echo "Error creating service...exiting."
  exit $?
fi

echo "Now waiting for jobs to finish"
kubectl get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | while read line; do wait_job_finish "pod/$line"; done

echo "Creating JMeter for the reactive server"
cat ${basedir}/../kubernetes/jmeter/jmeter-async.yml | sed "s/%%SERVER_HOST%%/$SERVER_ASYNC_IP/" | kubectl create -f -

if [ $? -ne 0 ]
then
  echo "Error creating service...exiting."
  exit $?
fi

echo "Now waiting for jobs to finish"
kubectl get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | while read line; do wait_job_finish "pod/$line"; done
