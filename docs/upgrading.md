# Upgrading

## Elasticsearch 6.8

Elasticsearch 9 refuses to open indices created in 6.8. It restores 6.8 snapshots only as archive indices, which need a paid licence. Copy the data from the 6.8 cluster with reindex from remote.

The manifests changed for Elasticsearch 9:

- The StatefulSet sets `node.processors` in place of `processors`, which Elasticsearch 9 ignores.
- Elasticsearch 9 refuses to start with `node.ingest` or `xpack.monitoring.enabled`. The node takes the ingest role from the default `node.roles`.
- Elasticsearch logs a deprecation warning for `xpack.monitoring.collection.enabled` and `xpack.monitoring.exporters.default_local.type`. Elastic will remove both in a future release. The image and StatefulSet leave both at their defaults, which keep legacy monitoring collection off.
- The pod exposes ports `9200` and `9300` only. [Metrics](./configuration.md#metrics) describes how Elasticsearch reports metrics.

## Selector labels

Release `v2026.06` moved the StatefulSet and Service selectors from the legacy `app: elasticsearch` label to the standard `app.kubernetes.io/name: elasticsearch` label. Kubernetes treats `.spec.selector` on a StatefulSet as immutable. Delete a StatefulSet created from an earlier release and create it again:

```sh
kubectl delete statefulset -n elasticsearch elasticsearch
kubectl apply -n elasticsearch -k deployment/
```

Deleting the StatefulSet deletes its pods, and Kubernetes deletes each pod's `emptyDir` volume with it. Copy the data to another cluster or take a snapshot before deleting the StatefulSet.
