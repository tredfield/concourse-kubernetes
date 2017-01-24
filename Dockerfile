# deploy-concourse

FROM alpine:3.2

RUN apk update
RUN apk upgrade
RUN apk add curl bash openssh-client

ENV K8S_VERSION=v1.5.1

ADD https://storage.googleapis.com/kubernetes-release/release/$K8S_VERSION/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

ADD . /deploy-concourse

ENTRYPOINT ["/deploy-concourse/deploy-concourse.sh"]
