# Harness Delegate

[Harness Delegate](https://docs.harness.io/article/de9t8iiynt-harness-architecture) is a service you run in your local network or VPC to connect your artifact servers, infrastructure, collaboration, and verification providers with the Harness Manager.

## Introduction

This chart creates a [Harness Delegate](https://docs.harness.io/article/h9tkwmkrm7-delegate-installation) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.


## Installing the Chart
To add Harness helm repo with name `harness-delegate`:

This chart is only compatible with helm version >= 3.2

```console
$ helm repo add harness-delegate https://app.harness.io/storage/harness-download/delegate-helm-chart
```

Note: Older helm chart repo: https://app.harness.io/storage/harness-download/harness-helm-charts is DEPRECATED and receives no further update, please use the new repo mentioned above.

The chart requires some account specific information. To install harness delegate using helm chart go to delegates page in harness UI
and click on install delegate using helm chart. Follow on screen instructions to install harness-delegate using helm.


## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm uninstall my-release
```

## Useful commands

Get pod names:

```console
kubectl get pods -n <namespace>
```

See startup logs:

```console
kubectl logs <pod-name> -n <namespace> -f
```
Run a shell in a pod:

```console
kubectl exec <pod-name> -n <namespace> -it -- bash
```
