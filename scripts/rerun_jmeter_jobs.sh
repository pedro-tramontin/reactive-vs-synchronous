#!/bin/bash

gcloud container clusters get-credentials jmeter
kubectl delete job/sync-jmeter job/async-jmeter

source scripts/check_endpoint.sh

gcloud container clusters get-credentials sync
get_service_external_ip server-sync SERVER_SYNC_IP
echo "$SERVER_SYNC_IP"

gcloud container clusters get-credentials async
get_service_external_ip server-async SERVER_ASYNC_IP
echo "$SERVER_ASYNC_IP"

gcloud container clusters get-credentials jmeter
cat kubernetes/jmeter/jmeter-sync.yml | sed "s/%%SERVER_HOST%%/$SERVER_SYNC_IP/" | kubectl create -f -
cat kubernetes/jmeter/jmeter-async.yml | sed "s/%%SERVER_HOST%%/$SERVER_ASYNC_IP/" | kubectl create -f -

source scripts/check_job.sh
kubectl get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | while read line; do wait_job_finish "pod/$line"; done

echo "Finished"
