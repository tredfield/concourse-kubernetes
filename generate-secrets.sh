#!/bin/bash

set -e

# output colors
red='\033[0;31m'
green='\033[0;32m'
reset='\033[0m'

auth_user=$(echo concourse | base64)
auth_password=$(openssl rand -base64 32)
postgres_password=$(openssl rand -base64 32)

keydir=./concourse-keys
mkdir -p $keydir

echo -e "${green}Create key files${reset}"
ssh-keygen -t rsa -f $keydir/tsa_host_key -N ''
ssh-keygen -t rsa -f $keydir/session_signing_key -N ''
ssh-keygen -t rsa -f $keydir/worker_key -N ''

echo -e "${green}Set secret vars${reset}"
tsa_host_key=$(cat $keydir/tsa_host_key | base64)
session_signing_key=$(cat $keydir/session_signing_key | base64)
tsa_worker_private_key=$(cat $keydir/worker_key | base64)
tsa_authorized_keys=$(cat $keydir/worker_key.pub | base64)
tsa_public_key=$(cat $keydir/tsa_host_key.pub | base64)

echo -e "${green}Remove key files directory${reset}"
rm -rf $keydir

secrets_file=$(mktemp concourse-secrets.XXXXXX)

echo -e "${green}Generate $secrets_file file for kubernetes${reset}"
cat > $secrets_file <<-EOF
apiVersion: v1
kind: Secret
metadata:
  name: concourse-secrets2
type: Opaque
data:
  basic-auth-username: $auth_user
  basic-auth-password: $auth_password

  postgres-password: $postgres_password

  # 'web' keys
  tsa-host-key: $tsa_host_key
  tsa-authorized-keys: $tsa_authorized_keys
  session-signing-key: $session_signing_key

  # 'worker' keys
  tsa-public-key: $tsa_public_key
  tsa-worker-private-key: $tsa_worker_private_key

EOF

echo -e "${green}Call kubectl create on $secrets_file${reset}"
kubectl create -f $secrets_file
echo -e "${green}Remove $secrets_file${reset}"
rm $secrets_file
