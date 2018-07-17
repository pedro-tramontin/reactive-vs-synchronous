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
