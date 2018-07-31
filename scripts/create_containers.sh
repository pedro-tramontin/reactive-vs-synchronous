#!/bin/bash

usage="$(basename "$0") [-z ZONE] [-h]

Creates all the containers in Google Cloud to run the project

where:
    -z  set the ZONE (default: us-central1-a)
    -h  show this help text"

zone=us-central1-a

while getopts ':hz:' option; do
  case "$option" in
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


has_sync_container=$(gcloud container clusters list --format="get(name)" --filter="name:${container_sync}")
if [ -z "${has_sync_container}" ]
then
  echo "Creating the sync container"
  gcloud container clusters create ${container_sync} --num-nodes=2 --zone=${zone}
  
  message_if_error "Sync cluster creation error...exiting."
else
  echo "Sync conainer already exists"
fi


has_async_container=$(gcloud container clusters list --format="get(name)" --filter="name:${container_async}")
if [ -z "${has_async_container}" ]
then
  echo "Creating the reactive container"
  gcloud container clusters create ${container_async} --num-nodes=2 --zone=${zone}

  message_if_error "Reactive cluster creation error...exiting."
else
  echo "Reactive container already exists"
fi


has_jmeter_service_account=$(gcloud iam service-accounts list --format="get(email)" \
--filter="email:${jmeter_service_account}@${gc_project}.iam.gserviceaccount.com")
if [ -z "${has_jmeter_service_account}" ]
then
  echo "Creating service account for JMeter"
  gcloud iam service-accounts create ${jmeter_service_account}

  message_if_error "Service account creation error...exiting."
else
  echo "Service account already exists."
fi


gcloud projects add-iam-policy-binding ${gc-project} \
  --member serviceAccount:jmeter-service-account@${gc-project}.iam.gserviceaccount.com \
  --role roles/storage.admin

if [ $? -ne 0 ]
then
  echo "Error assigning role to service account...exiting."
  exit $?
fi


has_jmeter_container=$(gcloud container clusters list --format="get(name)" --filter="name:${container_jmeter}")
if [ -z "${has_jmeter_container}" ]
then
  echo "Creating the jmeter container"
  gcloud container clusters create ${container_jmeter} --num-nodes=2 --zone=${zone}

  message_if_error "JMeter cluster creation error...exiting."
else
  echo "JMeter conainer already exists"
fi


gsutil mb gs://jmeter-bucket-${gc-project}

if [ $? -ne 0 ]
then
  echo "JMeter bucket creation error...exiting."
  exit $?
fi
