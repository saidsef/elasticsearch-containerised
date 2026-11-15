# Upgrading

## Elasticsearch 6.8

Elasticsearch 9 cannot open indices created in 6.8. It restores 6.8 snapshots only as archive indices, which the free licence does not allow. Copy the data from the 6.8 cluster with reindex from remote.

The manifests changed for Elasticsearch 9:

- The StatefulSet sets `node.processors` in place of `processors`, which Elasticsearch 9 ignores.
- The StatefulSet no longer sets `node.ingest` or `xpack.monitoring.enabled`, because Elasticsearch 9 refuses to start with either of them.
- The pod no longer exposes port `9404` or carries the `prometheus.io` annotations. [Metrics](./configuration.md#metrics) explains why.

## Selector labels

Release `v2026.06` moved the StatefulSet and Service selectors from the legacy `app: elasticsearch` label to the standard `app.kubernetes.io/name: elasticsearch` label. Kubernetes does not allow changes to `.spec.selector` on a StatefulSet. Delete a StatefulSet created from an earlier release and create it again:

```sh
kubectl delete statefulset -n elasticsearch elasticsearch
kubectl apply -n elasticsearch -k deployment/
```

Deleting the StatefulSet deletes its pods, and Kubernetes deletes each pod's `emptyDir` volume with it. Copy the data to another cluster or take a snapshot before deleting the StatefulSet.
