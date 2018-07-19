#!/bin/bash

# Pass the name of a service to check ie: sh check-endpoint.sh staging-voting-app-vote
# Will run forever...
function get_service_external_ip() {
  external_ip=""
  while [ -z $external_ip ]; do
    echo "Waiting for end point..."
    external_ip=$(kubectl get svc $1 --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
    [ -z "$external_ip" ] && sleep 10
  done

  eval "$2=$external_ip"
}

# Pass the pod name from the jmeter job you want to wait to finish
# Ex.: pod/jmeter-sync-123iu9
# Will run forever...
function wait_job_finish() {
  last_line=""
  while [ "$last_line" != "... end of run" ]; do
    echo "Waiting for job $1 to finish..."
    last_line=$(kubectl logs $1 | tail -n 1)
    [ "$last_line" != "... end of run" ] && sleep 10
  done
}