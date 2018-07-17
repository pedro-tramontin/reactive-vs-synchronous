#!/bin/bash

function wait_job_finish() {
  last_line=""
  while [ "$last_line" != "... end of run" ]; do
    echo "Waiting for job to finish..."
    last_line=$(kubectl logs $1 | tail -n 1)
    [ "$last_line" != "... end of run" ] && sleep 10
  done
}
