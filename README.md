# Elasticsearch - Containerised [![CI](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/docker.yml/badge.svg)](#installed-plugins-list) [![Tagging](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/tagging.yml/badge.svg)](#installed-plugins-list) [![Release](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/release.yml/badge.svg)](#installed-plugins-list)

Elasticsearch is a distributed, RESTful search and analytics engine capable of solving a growing number of use cases. As the heart of the Elastic Stack, it centrally stores your data so you can discover the expected and uncover the unexpected.

>This default distribution is governed by the Elastic License, and includes the [full set of free features](https://www.elastic.co/subscriptions).

This will run Elasticsearch in a single node via `env` variable baked into the container, we can run the container service via `docker run` command or in Kubernetes `kubectl apply -k deployment/`.

## Metrics

A Prometheus metrics endpoint is exposed at `:9404/metrics` via the bundled [`jmx_prometheus_javaagent`](https://github.com/prometheus/jmx_exporter). These are JVM-level metrics (heap, GC, threads), not Elasticsearch domain metrics.

The Kubernetes Service exposes port `9404` and the pod carries `prometheus.io/scrape` annotations for auto-discovery.

## Upgrading

The StatefulSet and Service selectors now use the standard `app.kubernetes.io/name: elasticsearch` label. `.spec.selector` is immutable on a StatefulSet, so existing clusters running the legacy `app: elasticsearch` selector must be recreated:

```
kubectl delete sts elasticsearch --cascade=orphan
kubectl apply -k deployment/
```

`--cascade=orphan` keeps the running pods (and their `emptyDir` storage) in place while the StatefulSet object is replaced; the new StatefulSet adopts the existing pods on rollout.

## Installed Plugins list

- repository-gcs
- repository-s3
- discovery-ec2
- mapper-size
- mapper-murmur3
- mapper-annotated-text
- ingest-attachment
- analysis-icu
- analysis-phonetic

## Source

Our latest and greatest source of Jenkins can be found on [GitHub](#source). Fork us!

## Contributing

We would :heart:  you to contribute by making a [pull request](https://github.com/saidsef/elasticsearch-containerised/pulls).

Please read the official [Contribution Guide](./CONTRIBUTING.md) for more information on how you can contribute.
