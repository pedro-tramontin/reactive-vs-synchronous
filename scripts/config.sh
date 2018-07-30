#!/bin/bash

# Google Cloud project name
gc_project="pedront-test-project"

# Default zone
zone="us-central1-a"

## Docker --
# Repository name
docker_repository="pedront"

# Google Registry name
docker_registry="gcr.io"

# The tag prefix: registry/project
tag_repo="$docker_registry/$gc_project"
## Docker --


project_backend="rvss-backend"
project_sync="rvss-server-sync"
project_async="rvss-server-async"
project_jmeter="rvss-jmeter"
tag="latest"

container_sync="sync"
container_async="async"
container_jmeter="jmeter"
