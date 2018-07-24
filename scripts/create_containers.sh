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

echo "Creating the sync container"
# Creates the cluster to run the synchronous backend
gcloud container clusters create ${container_sync} --num-nodes=2 --zone=${zone}

if [ $? -ne 0 ]
then
  echo "Sync cluster creation error...exiting."
  exit $?
fi

echo "Creating the reactive container"
# Creates the cluster to run the reactive backend
gcloud container clusters create ${container_async} --num-nodes=2 --zone=${zone}

if [ $? -ne 0 ]
then
  echo "Reactive cluster creation error...exiting."
  exit $?
fi

echo "Creating service account for JMeter"
gcloud iam service-accounts create jmeter-service-account

if [ $? -ne 0 ]
then
  echo "Service account creation error...exiting."
  exit $?
fi

gcloud projects add-iam-policy-binding ${gc-project} \
  --member serviceAccount:jmeter-service-account@${gc-project}.iam.gserviceaccount.com \
  --role roles/storage.admin

if [ $? -ne 0 ]
then
  echo "Error assigning role to service account...exiting."
  exit $?
fi

echo "Creating the jmeter container"
# Creates the cluster to run the JMeter load testing
gcloud container clusters create ${container_jmeter} --num-nodes=1 --zone=${zone} \
  --service-account jmeter-service-account@${gc-project}.iam.gserviceaccount.com

if [ $? -ne 0 ]
then
  echo "JMeter cluster creation error...exiting."
  exit $?
fi

gsutil mb gs://jmeter-bucket-${gc-project}

if [ $? -ne 0 ]
then
  echo "JMeter bucket creation error...exiting."
  exit $?
fi
