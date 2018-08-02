#!/bin/bash

basedir=$(dirname -- "$0")

source ${basedir}/utils.sh


usage="$(basename "$0") [-z ZONE] [-o OUTPUT_DIR] [-h]

Recovers the JMeter reports from the Google Cloud Bucket.

where:
    -z  set the ZONE (default: us-central1-a)
    -o  output directory (default: .)
    -h  show this help text"

zone="us-central1-a"
output_dir="."

while getopts ':hz:' option; do
  case "$option" in
    z) zone=$OPTARG
       ;;
    o) output_dir=$OPTARG
       ;;
    h|*) echo "$usage"
       exit
       ;;
  esac
done
shift "$((OPTIND - 1))"


echo "Loading env variables"
source ${basedir}/config.properties


gsutil cp gs://jmeter-bucket-${gc_project}/sync.tar.gz ${output_dir}

message_if_error "Error downloading sync report...exiting."


gsutil cp gs://jmeter-bucket-${gc_project}/react.tar.gz ${output_dir}

message_if_error "Error downloading reactive report...exiting."
