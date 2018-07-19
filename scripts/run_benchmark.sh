#!/bin/bash

basedir=$(dirname -- "$0")

echo "Loading env variables"
source ${basedir}/config.sh


#source ${basedir}/build_deploy_images.sh

if [ $? -ne 0 ]
then
  echo "Error building and deploying images...exiting."
  exit $?
fi

#source ${basedir}/create_containers.sh -z ${zone}

if [ $? -ne 0 ]
then
  echo "Error creating cluster...exiting."
  exit $?
fi

#source ${basedir}/kubernetes_sync.sh -z ${zone}

if [ $? -ne 0 ]
then
  echo "Error creating synchronous servers...exiting."
  exit $?
fi

#source ${basedir}/kubernetes_async.sh -z ${zone}

if [ $? -ne 0 ]
then
  echo "Error creating reactive servers...exiting."
  exit $?
fi

echo "Waiting 60s for instances to settle"
for i in {60..10..10}
do
  echo -ne $i"s "\\r
  sleep 10s
done

#source ${basedir}/kubernetes_jmeter.sh -z ${zone}

echo "Now waiting for jobs to finish"
kubectl get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | while read line; do wait_job_finish "pod/$line"; done

echo "Downloading report files"
source ${basedir}/get_jmeter_reports.sh -z ${zone}

echo "Finished"