A simple Kubernetes implementation of the official Concourse [docker-compose.yml](https://concourse.ci/docker-repository.html).

This page describes how to deploy Concourse to a Kubernetes cluster.
Deploying Concourse in Kubernetes establishes the following:
NodePort Service for postgres
Deployment for postgres pod
LoadBalancer (AWS ELB) service for web (ATC)
Deployment for web pod
Deployment for worker pod (TSA)
The worker and/or web pod can be scaled by increasing the replication value in the corresponding yaml declarations: concourse-web-dep.yaml, concourse-worker-dep.yaml. Replicated worker/web self-register with ATC. They heartbeat to the ATC and will be removed if the pod is removed.
The services must be created before Deployments so that the Pods are registered with the appropriate environment variables (for the Services).


Step-by-step guide
Clone repo ci-concourse and change directory into ci-concourse/k8s
Update concourse-secrets.yaml accordingly but do not commit. Create Secrets with command:
kubectl apply -f concourse-secrets.yaml
Create Services with command:
for f in *-svc.yaml; do kubectl apply -f $f; done
Create Deployments with command:
for f in *-dep.yaml; do kubectl apply -f $f; done
