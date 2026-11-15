# Elasticsearch - Containerised [![CI](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/docker.yml/badge.svg)](#plugins) [![Tagging](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/tagging.yml/badge.svg)](#plugins) [![Release](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/release.yml/badge.svg)](#plugins)

Elasticsearch is a distributed, RESTful search and analytics engine capable of solving a growing number of use cases. As the heart of the Elastic Stack, it centrally stores your data so you can discover the expected and uncover the unexpected.

>This default distribution is governed by the Elastic License, and includes the [full set of free features](https://www.elastic.co/subscriptions).

This will run Elasticsearch in a single node via `env` variable baked into the container, we can run the container service via `docker run` command or in Kubernetes `kubectl apply -k deployment/`.

## Metrics

The image does not expose Prometheus metrics. The [`jmx_prometheus_javaagent`](https://github.com/prometheus/jmx_exporter) 1.6.0 fails on Elasticsearch 9.5.5 with `NoClassDefFoundError: com/sun/net/httpserver/Authenticator`, and the node does not start.

## Upgrading

### From 6.8

Elasticsearch 9 cannot open indices created in 6.8. It restores 6.8 snapshots only as archive indices, which the free licence does not allow. Copy the data from the 6.8 cluster with reindex from remote.

- `node.processors` replaces `processors`. Elasticsearch 9 ignores the old variable.
- `node.ingest` and `xpack.monitoring.enabled` are removed, because Elasticsearch 9 refuses to start with them.
- Port `9404` and the `prometheus.io` annotations are removed.

### Selector labels

The StatefulSet and Service selectors now use the standard `app.kubernetes.io/name: elasticsearch` label. `.spec.selector` is immutable on a StatefulSet, so existing clusters running the legacy `app: elasticsearch` selector must be recreated:

```
kubectl delete sts elasticsearch --cascade=orphan
kubectl apply -k deployment/
```

`--cascade=orphan` keeps the running pods (and their `emptyDir` storage) in place while the StatefulSet object is replaced; the new StatefulSet adopts the existing pods on rollout.

## Plugins

The image does not install any plugins. Elasticsearch 9 ships the S3 and GCS snapshot repositories and the attachment processor as built-in modules.

## Source

Our latest and greatest source of Jenkins can be found on [GitHub](#source). Fork us!

## Contributing

We would :heart:  you to contribute by making a [pull request](https://github.com/saidsef/elasticsearch-containerised/pulls).

Please read the official [Contribution Guide](./CONTRIBUTING.md) for more information on how you can contribute.
