#!/bin/bash

set -e -x

server=${1:-https://tectonic-k8s.ext.dev00.scpdev.net:443}
cluster=${2:-tectonic}

kubectl create serviceaccount concourse-ci
secretname=$(kubectl get serviceaccount concourse-ci -o json | jq -r '.secrets[0].name')
token=$(kubectl get secret $secretname -o json | jq -r '.data.token' | base64 --decode; echo)
kubectl config set-credentials concourse-ci --token=$token
kubectl get secret $secretname -o json | jq -r '.data."ca.crt"' | base64 -D > ca.pem
kubectl config set-cluster tectonic --certificate-authority=ca.pem --embed-certs=true --server=$server
kubectl config set-context concourse-worker-ci --user=concourse-ci --cluster=$cluster
kubectl config use-context concourse-worker-ci
kubectl create -f concourse-service-account-role.yaml
