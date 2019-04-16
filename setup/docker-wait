#!/bin/bash

# Wait for docker
# keep also date in logs
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e "${GREEN}$(date) starting to wait for docker socket${NC}"

tries=0
while [ ! -e "/var/run/docker.pid" ] || [ ! -e "/var/run/docker.sock" ]; do
  sleep 1
  tries=$(($tries + 1))
  if [ $tries -gt 60 ]; then
      echo "Gave up waiting for docker socker after: ${tries} seconds"
      exit 1;
  fi
  echo "docker socket does not exist after: ${tries} seconds"
done
