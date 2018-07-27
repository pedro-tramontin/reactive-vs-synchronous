#!/bin/bash

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

PROJECT_ID=$1

temp=$(gcloud projects list --format="get(name)" --filter="name:${PROJECT_ID}")

if [ -z "$out" ]
then
    echo "Project ${PROJECT_ID} doesn't exist"
else
    echo ${PROJECT_ID}
fi
