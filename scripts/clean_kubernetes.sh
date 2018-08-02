#!/bin/bash

basedir=$(dirname -- "$0")

source ${basedir}/utils.sh


usage="$(basename "$0") [-z ZONE] [-h]

Deletes all the resources that where created to run the benchmark.

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


echo "Loading env variables"
source ${basedir}/config.sh


echo "Deleting clusters..."


has_sync_container=$(gcloud container clusters list --format="get(name)" \
  --filter="name=${container_sync}")
if [ -n "${has_sync_container}" ]
then
  echo "Sync container..."
  gcloud container clusters delete ${container_sync} --zone=${zone} --quiet

  message_if_error "Error deleting sync cluster...exiting."
else
  echo "Sync container doesn't exist"
fi


has_async_container=$(gcloud container clusters list --format="get(name)" \
  --filter="name=${container_async}")
if [ -n "${has_async_container}" ]
then
  echo "Reactive container..."
  gcloud container clusters delete ${container_async} --zone=${zone} --quiet

  message_if_error "Error deleting reactive cluster...exiting."
else
  echo "Reactive container doesn't exist"
fi


has_jmeter_container=$(gcloud container clusters list --format="get(name)" \
  --filter="name=${container_jmeter}")
if [ -n "${has_jmeter_container}" ]
then
  echo "JMeter container..."
  gcloud container clusters delete ${container_jmeter} --zone=${zone} --quiet

  message_if_error "Error deleting JMeter cluster...exiting."
else
  echo "JMeter container doesn't exist"
fi


is_service_account_binded=$(gcloud projects get-iam-policy ${gc_project} \
  --flatten="bindings[].members[]" --format="get(bindings.members)" \
  --filter="bindings.members:serviceAccount:${jmeter_service_account}* AND \
            bindings.role:roles/storage.admin")
if [ -n "${is_service_account_binded}" ]
then
  echo "JMeter service account binding"
  gcloud projects remove-iam-policy-binding ${gc_project} \
    --member serviceAccount:${jmeter_service_account}@${gc_project}.iam.gserviceaccount.com \
    --role roles/storage.admin \
    --quiet

  message_if_error "Error removing binding from service account...exiting."
else
  echo "Role not assigned to service account."
fi


has_jmeter_service_account=$(gcloud iam service-accounts list --format="get(email)" \
--filter="email:${jmeter_service_account}@${gc_project}.iam.gserviceaccount.com")
if [ -n "${has_jmeter_service_account}" ]
then
  echo "JMeter service account"
  gcloud iam service-accounts delete ${jmeter_service_account}@${gc_project}.iam.gserviceaccount.com --quiet

  message_if_error "Error deleting JMeter service account...exiting."
else
  echo "JMeter service account doesn't exist"
fi


has_bucket=false
for bucket in $(gsutil ls gs://);
do
  if [ "${bucket}" = "gs://jmeter-bucket-${gc_project}/" ];
  then
    has_bucket=true
  fi
done


if [ "${has_bucket}" = true ];
then
  gsutil rm -r gs://jmeter-bucket-${gc_project}/

  message_if_error "Error removing JMeter bucket...exiting."
else
  echo "JMeter bucket doesn't exist"
fi
