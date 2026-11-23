# Installation

## Requirements

- A `linux/amd64` host or node, the only platform the CI workflow builds the image for
- Docker, or Kubernetes and `kubectl` with Kustomize support for the manifests in [`deployment/`](https://github.com/saidsef/elasticsearch-containerised/tree/main/deployment)
- A node with enough free memory for the pod's request in [Resources](./configuration.md#resources)

## Docker

The image runs Elasticsearch as a single node with the settings in [Image settings](./configuration.md#image-settings):

```sh
docker run -d --name elasticsearch -p 9200:9200 docker.io/saidsef/elasticsearch:latest
curl 'http://localhost:9200/_cat/health?v'
```

Elasticsearch sets its heap size from the memory available to the container unless `ES_JAVA_OPTS` sets it. [StatefulSet settings](./configuration.md#statefulset-settings) shows how the StatefulSet fixes the heap.

`latest` follows `main`. [Versions](./versions.md) lists every tag and the Elasticsearch version it runs.

## Kubernetes

From a clone of the repository, create a namespace and apply the manifests:

```sh
kubectl create namespace elasticsearch
kubectl apply -n elasticsearch -k deployment/
kubectl rollout status -n elasticsearch statefulset/elasticsearch
```

The manifests create a StatefulSet named `elasticsearch` with one pod, and a ClusterIP Service of the same name, in the namespace that `-n` names. [Configuration](./configuration.md) describes both.

## Health checks

Forward the Service port to the local machine:

```sh
kubectl port-forward -n elasticsearch svc/elasticsearch 9200:9200
```

From a second terminal:

```sh
curl 'http://localhost:9200/_cat/health?v'
```

The cluster reports `green` until an index has a replica. Elasticsearch places each replica on a different node from its primary shard. On a single node, an index with the default single replica leaves that replica unassigned and turns the cluster `yellow`. To keep the cluster `green`, create indices with `number_of_replicas` set to `0`.
