#!/bin/bash

set -e

# output colors
red='\033[0;31m'
green='\033[0;32m'
reset='\033[0m'

DEFAULT_KUBE_SERVER=https://tectonic-k8s.ext.dev00.scpdev.net:443

if [ -z "$KUBE_SERVER" ]
then
  echo -e "${red}\$KUBE_SERVER is empty, defaulting to $DEFAULT_KUBE_SERVER${reset}"
  KUBE_SERVER=$DEFAULT_KUBE_SERVER
else
  echo -e "${green}Using \$KUBE_SERVER $KUBE_SERVER${reset}"
fi

secretname=$(kubectl get serviceaccount concourse-ci -o json | jq -r '.secrets[0].name')
export KUBE_CA_TOKEN=$(kubectl get secret $secretname -o json | jq -r '.data.token' | base64 --decode;echo)
export KUBE_CA_DATA=$(kubectl get secret $secretname -o json | jq -r '.data."ca.crt"')

echo -e "${green}Set values for \$KUBE_CA_TOKEN and \$KUBE_CA_DATA${reset}"

echo -e "${green}Building Docker image...${reset}"
docker build -t deploy-concourse .

echo -e "${green}Running Docker image...${reset}"
docker run -e KUBE_CA_DATA -e KUBE_CA_TOKEN -e KUBE_SERVER deploy-concourse
