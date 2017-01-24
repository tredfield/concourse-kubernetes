# concourse-kubernetes

A simple Kubernetes implementation of the official Concourse [docker-compose.yml](https://concourse.ci/docker-repository.html).

This page describes how to deploy Concourse to a Kubernetes cluster.

Deploying Concourse in Kubernetes establishes the following:
- NodePort Service for postgres
- Deployment for postgres pod
- LoadBalancer (AWS ELB) service for web (ATC)
- Deployment for web pod
- Deployment for worker pod (TSA)

The worker and/or web pod can be scaled by increasing the replication value in the corresponding yaml declarations: concourse-web-dep.yaml, concourse-worker-dep.yaml. Replicated worker/web self-register with ATC. They heartbeat to the ATC and will be removed if the pod is removed.

The services must be created before Deployments so that the Pods are registered with the appropriate environment variables (for the Services).

## Prerequisites
- kubectl configured
- concourse-ci service account created in Kubernetes

## Step-by-step guide
- Clone this repo and change directory into where it was cloned
- Create environment variables for kubectl server, concourse-ci token, and ca.cert from concourse-ci service account:
  - `export KUBE_SERVER=<url to k8s server>`
  - `export KUBE_CA_DATA=<ca.cert>`
  - `export KUBE_CA_TOKEN=<concourse-ci service account token>`
- Run the docker commands:
  - `docker build -t deploy-concourse .`
  - `docker run -e KUBE_CA_DATA -e KUBE_CA_TOKEN -e KUBE_SERVER deploy-concourse`
