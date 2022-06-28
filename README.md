# ArgoCD with kustomize-pass

This is a [build-your-own-image](https://argo-cd.readthedocs.io/en/stable/operator-manual/custom_tools/#byoi-build-your-own-image) of [ArgoCD](https://argoproj.github.io/cd/) with the [kustomize-pass](https://github.com/ftsell/kustomize-pass) plugin preinstalled.
This effectively enables *ArgoCD* users to extract secrets from [pass](https://www.passwordstore.org/) transparently and have them deployed by *ArgoCD*.

## Supported ArgoCD Versions

The latest *ArgoCD* release is automatically rebuilt and published to the GitHub image registry.
However, this really **only includes the latest *ArgoCD* release**.
If you or your organisation needs another version, you will have to build the image yourself or use one of the older image tags if GitHub hasn't deleted it yet.

## Usage

1. This repository contains the source *Dockerfile* to build an image derived from `quay.io/argoproj/argocd`.
   You can either use the *Dockerfile* to build your own image or use the provided image from [`ghcr.io/ftsell/argocd-kustomize-pass:v2.4.3`](https://github.com/ftsell/argocd-kustomize-pass/pkgs/container/argocd-kustomize-pass).

   This repository does not contain helm charts or other *ArgoCD* related manifests.
   This means that, in order to use this, you will have to follow the upstream *ArgoCD* instructions in order to deploy it but instead of using the normal image, you will have to use this repositories image instead for the `argocd-repo-server` deployment.

2. Additionally, you will need to configure *ArgoCD* to provide a secret gpg key in order for the *pass* password store to be decrypted.

   However, this is not yet documented but will be soon.

### Usage example

For example, if you deploy *ArgoCD* via kustomize, you could use the following kustomization:
```yaml
# kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.3/manifests/ha/install.yaml
images:
  - name: quay.io/argoproj/argocd
    newName: ghcr.io/ftsell/argocd-kustomize-pass
```
