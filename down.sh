#!/bin/bash

# Test for Docker compose v2
docker compose &>/dev/null
if [ $? -ne 0 ]; then
  echo "Docker compose v2 is not installed.  Please ensure your Docker installation is up-to-date, and that docker-compose-plugin is installed"
  exit 1
fi

set -e
docker compose down