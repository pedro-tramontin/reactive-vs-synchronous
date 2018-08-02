#!/bin/bash

basedir=$(dirname -- "$0")

source ${basedir}/utils.sh


usage="$(basename "$0") [-h]

Creates the bucket to JMeter results

where:
    -h  show this help text"

while getopts ':h' option; do
  case "$option" in
    h|*) echo "$usage"
       exit
       ;;
  esac
done
shift "$((OPTIND - 1))"

echo "Loading env variables"
source ${basedir}/config.sh

has_bucket=false

for bucket in $(gsutil ls gs://);
do
  if [ "${bucket}" = "gs://jmeter-bucket-${gc_project}/" ];
  then
    has_bucket=true
  fi
done

if [ "${has_bucket}" = false ];
then
  gsutil mb gs://jmeter-bucket-${gc_project}/

  message_if_error "JMeter bucket creation error...exiting."
else
  echo "JMeter bucket already exists."
fi
