#!/bin/bash

basedir=$(dirname -- "$0")

source ${basedir}/utils.sh


usage="$(basename "$0") PROJECT_ID [-q] [-h]

Creates a project in Google Cloud

where:
    [PROJECT_ID] ID for the project to be created

    -q  don't ask for user input
    -h  show this help text"

quiet=false

while getopts ':hq' option; do
  case "$option" in
    q) quiet=true
       ;;
    h|*) echo "$usage"
       exit
       ;;
  esac
done
shift "$((OPTIND - 1))"

# Gets first posicional argument
if [ -z "$1" ]
then
  echo "$usage"
  exit
fi

project_id=$1

filter_result=$(gcloud projects list --format="get(projectId)" --filter="name:${project_id}")

if [ -n "${filter_result}" ]
then
  echo "Project ${project_id} already exists."
else
  gcloud projects create ${project_id}

  message_if_error "Project creation error...exiting"
fi

echo "Setting project ${project_id} as default"

gcloud config set core/project ${project_id}

message_if_error "Error setting project ${project_id} as default...exiting"

billing_enabled=$(gcloud beta billing projects describe pedront-test-project --format="get(billingEnabled)")
if [ -z "${billing_enabled}" ]
then
  echo "Enabling billing for project ${project_id}."

  billing_account=$(gcloud beta billing accounts list --format="get(name)" --limit=1)

  message_if_error "Error getting billing account...exiting"

  if [ -z "${billing_account}" ]
  then
    echo "No billing account found."
    exit 0
  fi

  echo "Using billing account: ${billing_account}"

  gcloud beta billing projects link ${project_id} --billing-account ${billing_account}

  message_if_error "Error setting billing account...exiting"
else
  echo "Billing already enabled for project ${project_id}"
fi

has_container_registry=$(gcloud services list --format="get(serviceConfig.name)" --filter="serviceConfig.name:containerregistry.googleapis.com")
if [ -z "${has_container_registry}" ]
then
  echo "Enabling container registry service"

  gcloud services enable containerregistry.googleapis.com

  message_if_error "Error enabling container registry...exiting"
else
  echo "Container Registry already enabled"
fi
