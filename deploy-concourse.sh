#!/bin/bash

set -e

cd /deploy-concourse

# output colors
red='\033[0;31m'
green='\033[0;32m'
reset='\033[0m'

# environment variables for kubectl service account must be set
./generate-secrets.sh

# create services
echo -e "${green}Create services...${reset}"
for f in *-svc.yaml; do ./kubectl.sh $f; done

# create deployments
echo -e "${green}Create deployments...${reset}"
for f in *-dep.yaml; do ./kubectl.sh $f; done

echo -e "${green}Done${reset}"
