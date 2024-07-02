FROM quay.io/argoproj/argocd:v2.11.4 as argocd

# provide /usr/local/bin/kustomize5 for compatibility purposes
USER root
RUN ln -s $(which kustomize) /usr/local/bin/kustomize5

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
