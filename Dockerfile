# build a kustomize version with patched issue
FROM docker.io/golang:1.20-bullseye as build-kustomize
WORKDIR /app
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&\
    apt-get install -y build-essential git
RUN git clone https://github.com/kubernetes-sigs/kustomize.git &&\
    cd kustomize/kustomize &&\
    git fetch origin release-kustomize-v5.0 &&\
    git checkout release-kustomize-v5.0 &&\
    go build .



FROM quay.io/argoproj/argocd:v2.8.2 as argocd
# install kustomize with patched issue
COPY --from=build-kustomize /app/kustomize/kustomize/kustomize /usr/local/bin/kustomize5

# install kustomize-pass and its dependencies
ARG KUSTOMIZE_PASS_VERSION=v0.5.1
USER root
RUN apt-get update && \
    apt-get install -y wget libgpgme11 pass && \
    \
    wget "https://github.com/ftsell/kustomize-pass/releases/download/$KUSTOMIZE_PASS_VERSION/kustomize-pass--linux-ubuntu-2204" -O /usr/local/bin/kustomize-pass &&\
    chmod +x /usr/local/bin/kustomize-pass &&\
    \
    apt-get remove -y wget &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# switch back to non-root user for normal operation
USER 999
