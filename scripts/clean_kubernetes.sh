#!/bin/bash

echo "Getting auth for the sync cluster"
gcloud container clusters get-credentials sync

kubectl delete deployment/backend-sync
kubectl delete deployment/server-sync
kubectl delete service/backend-sync
kubectl delete service/server-sync

echo "Getting auth for the async cluster"
gcloud container clusters get-credentials async

kubectl delete deployment/backend-async
kubectl delete deployment/server-async
kubectl delete service/backend-async
kubectl delete service/server-async

echo "Getting auth for the jmeter cluster"
gcloud container clusters get-credentials jmeter

kubectl delete job/sync-jmeter
kubectl delete job/async-jmeter

gcloud compute disks delete --quiet jmeter-sync-volume
gcloud compute disks delete --quiet jmeter-async-volume
