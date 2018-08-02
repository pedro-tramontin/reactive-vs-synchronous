#!/bin/bash

basedir=$(dirname -- "$0")

source ${basedir}/utils.sh


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


echo "Loading env variables"
source ${basedir}/config.sh


has_jmeter_container=$(gcloud container clusters list --zone=${zone} --format="get(name)" \
  --filter="name=${container_jmeter}")
if [ -z "${has_jmeter_container}" ]
then
  echo "JMeter container doesn't exists...exiting."

  exit 1
fi


echo "Getting auth for the JMeter cluster"
gcloud container clusters get-credentials ${container_jmeter} --zone=${zone}

message_if_error "Error getting auth...exiting."


has_dep_jmeter_sync=$(kubectl get jobs --field-selector='metadata.name=sync-jmeter' \
  -o jsonpath='{.items[*].metadata.name}')
if [ -z "${has_dep_jmeter_sync}" ]
then
  echo "Creating JMeter for the synchronous server"
  cat ${basedir}/../kubernetes/jmeter/jmeter-sync.yml | \
    sed "s/%%SERVER_HOST%%/${SERVER_SYNC_IP}/" | \
    sed "s/%%GC_PROJECT%%/${gc_project}/" | \
    sed "s/%%BUCKET_NAME%%/jmeter-bucket-${gc_project}/" | \
    kubectl create -f -

  message_if_error  "Error creating JMeter deployment...exiting."
else
  echo "JMeter deployment already exists."
fi


echo "Now waiting for jobs to finish"
kubectl get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | \
  while read line; do wait_job_finish "pod/$line"; done


has_dep_jmeter_async=$(kubectl get jobs --field-selector='metadata.name=async-jmeter' \
  -o jsonpath='{.items[*].metadata.name}')
if [ -z "${has_dep_jmeter_async}" ]
then
  echo "Creating JMeter for the reactive server"
  cat ${basedir}/../kubernetes/jmeter/jmeter-async.yml | \
    sed "s/%%SERVER_HOST%%/${SERVER_ASYNC_IP}/" | \
    sed "s/%%GC_PROJECT%%/${gc_project}/" | \
    sed "s/%%BUCKET_NAME%%/jmeter-bucket-${gc_project}/" | \
    kubectl create -f -

  message_if_error  "Error creating JMeter reactive deployment...exiting."
else
  echo "JMeter reactive deployment already exists."
fi


echo "Now waiting for jobs to finish"
kubectl get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | while read line; do wait_job_finish "pod/$line"; done
