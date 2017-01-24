#!/bin/bash

set -e

ca_data=$KUBE_CA_DATA
id_token=$KUBE_CA_TOKEN
server=$KUBE_SERVER
file=$1

cat > kubeconfig <<-EOF
apiVersion: v1
kind: Config

clusters:
- cluster:
    server: $server
    certificate-authority-data: $ca_data
  name: tectonic

users:
- name: concourse-ci
  user:
    token: $id_token

preferences: {}

contexts:
- context:
    cluster: tectonic
    user: concourse-ci
  name: concourse-worker-ci

current-context: concourse-worker-ci

EOF

kubectl --kubeconfig='kubeconfig' apply -f "$file"
rm kubeconfig
