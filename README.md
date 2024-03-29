# ArgoCD with kustomize-pass

This is a [build-your-own-image](https://argo-cd.readthedocs.io/en/stable/operator-manual/custom_tools/#byoi-build-your-own-image) of [ArgoCD](https://argoproj.github.io/cd/) with the [kustomize-pass](https://github.com/ftsell/kustomize-pass) plugin preinstalled.
This effectively enables *ArgoCD* users to extract secrets from [pass](https://www.passwordstore.org/) transparently and have them deployed by *ArgoCD*.

## Disclaimer

kustomize recently had an issue regarding the execution of krm functions (*kustomize-pass* is one) which prevented the execution of it under some circumstances.
The issue has been fixed in kustomize v5.0.0.

Previous versions of this image shipped a custom kustomize binary at
`/usr/local/bin/kustomize5` because ArgoCD did not ship with kustomize v5 yet.
By now ArgoCD has updated its shipped kustomize version so the `/usr/local/bin/kustomize5`
binary is no longer required.
It will be removed in a future version of this image but is kept in until March 2024 for
compatibility reasons.

**After March 31. 2024 `/usr/local/bin/kustomize5` will no longer be shipped in the
image**.

## Supported ArgoCD Versions

The latest *ArgoCD* release is automatically rebuilt and published to the GitHub image registry.
However, this really **only includes the latest *ArgoCD* release**.
If you or your organisation needs another version, you will have to build the image yourself or use one of the older image tags if GitHub hasn't deleted it yet.

## Usage

1. This repository contains the source *Dockerfile* to build an image derived from `quay.io/argoproj/argocd`.
   You can either use the *Dockerfile* to build your own image or use the provided image from [`ghcr.io/ftsell/argocd-kustomize-pass`](https://github.com/ftsell/argocd-kustomize-pass/pkgs/container/argocd-kustomize-pass).

   This repository does not contain helm charts or other *ArgoCD* related manifests.
   This means that, in order to use this, you will have to follow the upstream *ArgoCD* instructions in order to deploy it but instead of using the normal image, you will have to use this repositories image instead for the `argocd-repo-server` deployment.

2. Additionally, you will need to configure *ArgoCD* a bit to allow *kustomize-pass* to work correctly:
   1. Create a gpg secret key and provide it to *ArgoCD* inside its *gpg-keys* volume.
      The file must be named like the key fingerprint.
      On startup, *ArgoCD* will automatically load all key files (public and secret) from here into a keyring.
   2. Set the environment variable `XDG_DATA_HOME` to some place that *kustomize-pass* can write files.
      This is required because the *ArgoCD* manifests run the container with a read-only filesystem by default.
      A possible value would be `XDG_DATA_HOME=/tmp/data`.
   3. Se the environment variable `GNUPGHOME=/app/config/gpg/keys` because that is where *ArgoCD* accumulates all keys during startup.

### Usage Example

This project is used by [Viva con Agua](https://www.vivaconagua.org/) to deploy its *ArgoCD*.
You can view the deployment configuration at the [Viva-con-Agua/argocd-deploy](https://github.com/Viva-con-Agua/argocd-deploy) repository.
