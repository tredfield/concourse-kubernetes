# concourse-kubernetes

This page describes how to deploy Concourse to a Kubernetes cluster.

Deploying Concourse in Kubernetes establishes the following:
- NodePort Service for postgres
- Deployment for postgres pod
- LoadBalancer (AWS ELB) service for web (ATC)
- Deployment for web pod
- Deployment for worker pod (TSA)

The worker and/or web pod can be scaled by increasing the replication value in the corresponding yaml declarations: concourse-web-dep.yaml, concourse-worker-dep.yaml. Replicated worker/web self-register with ATC. They heartbeat to the ATC and will be removed if the pod is removed.

The services must be created before Deployments so that the Pods are registered with the appropriate environment variables (for the Services).

# Step-by-step guide
1 Clone repo ci-concourse and change directory into ci-concourse/k8s
2 The concourse-ci service account must first be created, see Create k8s Service Account.
3 Run Docker image using:
  - Option 1
    - Create environment variables for concourse-ci service account:
      KUBE_SERVER   # url to k8s server
      KUBE_CA_DATA  # ca.cert
      KUBE_CA_TOKEN  # concourse-ci service account token
      KUBE_NAMESPACE # namespace to deploy concourse
    - Run the docker commands:
      `docker build -t deploy-concourse .
      docker run -e KUBE_CA_DATA -e KUBE_CA_TOKEN -e KUBE_SERVER -e KUBE_NAMESPACE deploy-concourse`

  - Option 2
    - Assure kubectl is configured to correct kubernetes environment that should be used to retrieve the concourse-ci service account ca.cert and token.
    - Default KUBE_SERVER is set to https://tectonic-k8s.ext.dev00.scpdev.net:443, export KUBE_SERVER and KUBE_NAMESPACE to override
    - Run command
      `./docker-deploy-concourse.sh`
