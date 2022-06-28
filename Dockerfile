FROM docker.io/argoproj/argocd:v2.4.3

# install kustomize-tools and its dependencies
ARG KUSTOMIZE_PASS_VERSION=v0.3.1
USER root
RUN apt-get update && \
    apt-get install -y wget libgpgme11 && \
    \
    wget "https://github.com/ftsell/kustomize-pass/releases/download/$KUSTOMIZE_PASS_VERSION/kustomize-pass--linux-ubuntu-2204" -O /usr/local/bin/kustomize-pass &&\
    chmod +x /usr/local/bin/kustomize-pass &&\
    \
    apt-get remove -y wget &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# switch back to non-root user for normal operation
USER 999
