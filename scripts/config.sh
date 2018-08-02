#!/bin/bash

# Google Cloud project name
gc_project="pedront-test-project2"

# Default zone
zone="us-central1-a"

## Docker --
# Google Registry name
docker_registry="gcr.io"

# Repository name
docker_repository="pedront"

docker_tag="latest"

# The tag prefix: registry/project
image_prefix="$docker_registry/$gc_project"

# Image names
project_backend="rvss-backend"
project_sync="rvss-server-sync"
project_async="rvss-server-async"
project_jmeter="rvss-jmeter"
## Docker --

# Containers
container_sync="sync"
container_async="async"
container_jmeter="jmeter"

# Service accounts
jmeter_service_account="jmeter-service-account"

# APP names
app_backend_sync="backend-sync"
app_server_sync="server-sync"
app_jmeter_sync="sync-jmeter"
app_backend_async="backend-async"
app_server_async="server-async"
app_jmeter_async="async-jmeter"

# JMeter reports
jmeter_report_sync="sync"
jmeter_report_async="react"
