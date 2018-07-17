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

echo "Creating the sync container"
# Creates the cluster to run the synchronous backend
gcloud container clusters create sync --num-nodes=2 --zone=$zone

if [ $? -ne 0 ]
then
  echo "Sync cluster creation error...exiting."
  exit $?
fi

echo "Creating the reactive container"
# Creates the cluster to run the reactive backend
gcloud container clusters create async --num-nodes=2 --zone=$zone

if [ $? -ne 0 ]
then
  echo "Reactive cluster creation error...exiting."
  exit $?
fi

echo "Creating the jmeter container"
# Creates the cluster to run the JMeter load testing
gcloud container clusters create jmeter --num-nodes=2 --zone=$zone

if [ $? -ne 0 ]
then
  echo "JMeter cluster creation error...exiting."
  exit $?
fi
