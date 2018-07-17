#!/bin/bash

gcloud compute instances create jmeter-instance --zone us-central1-a
gcloud compute instances attach-disk jmeter-instance --disk=jmeter-sync --zone=us-central1-a
gcloud compute instances attach-disk jmeter-instance --disk=jmeter-async --zone=us-central1-a

gcloud compute ssh --zone us-central1-a jmeter-instance -- 'sudo mkdir /mnt/sync /mnt/async'
gcloud compute ssh --zone us-central1-a jmeter-instance -- 'sudo mount /dev/sdb /mnt/sync'
gcloud compute ssh --zone us-central1-a jmeter-instance -- 'sudo mount /dev/sdc /mnt/async'
gcloud compute ssh --zone us-central1-a jmeter-instance -- 'cd /mnt/sync/sync && sudo tar -czf sync.tar.gz report/ results.csv'
gcloud compute ssh --zone us-central1-a jmeter-instance -- 'cd /mnt/async/async && sudo tar -czf async.tar.gz report/ results.csv'
gcloud compute scp jmeter-instance:/mnt/sync/sync/sync.tar.gz .
gcloud compute scp jmeter-instance:/mnt/async/async/async.tar.gz .
gcloud compute ssh --zone us-central1-a jmeter-instance -- 'sudo rm -rf /mnt/sync/sync && sudo rm -rf /mnt/async/async'

gcloud compute instances delete jmeter-instance --quiet
