#!/bin/bash

basedir=$(dirname -- "$0")

source ${basedir}/config.properties


source ${basedir}/create_project.sh ${gc_project}

message_if_error "Error creating project...exiting."


source ${basedir}/build_deploy_images.sh

message_if_error "Error building and deploying images...exiting."


source ${basedir}/create_containers.sh -z ${zone}

message_if_error "Error creating cluster...exiting."


source ${basedir}/create_bucket.sh

message_if_error "Error creating bucket...exiting."


source ${basedir}/kubernetes_sync.sh -z ${zone}

message_if_error  "Error creating synchronous servers...exiting."


source ${basedir}/kubernetes_async.sh -z ${zone}

message_if_error  "Error creating reactive servers...exiting."


echo "Waiting 60s for instances to settle"
for i in {60..10..10}
do
  echo -ne $i"s "\\r
  sleep 10s
done


source ${basedir}/kubernetes_jmeter.sh -z ${zone}

message_if_error  "Error running JMeter...exiting."


echo "Downloading report files"
source ${basedir}/download_jmeter_reports.sh -z ${zone}

message_if_error  "Error donwloading reports...exiting."


echo "Finished"
