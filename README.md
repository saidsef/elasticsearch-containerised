# Elasticsearch - Containerised [![CI](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/docker.yml/badge.svg)](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/docker.yml) [![Tagging](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/tagging.yml/badge.svg)](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/tagging.yml) [![Release](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/release.yml/badge.svg)](https://github.com/saidsef/elasticsearch-containerised/actions/workflows/release.yml)

Elasticsearch is a distributed search and analytics engine with a REST API, and the centre of the Elastic Stack.

> The Elastic License covers this default distribution, which includes the [full set of free features](https://www.elastic.co/subscriptions).

This repository builds a Docker image that runs Elasticsearch as a single node, with its settings in environment variables. The Kustomize manifests in `deployment/` run the image on Kubernetes as a StatefulSet.

## Quick start

```sh
docker run -d --name elasticsearch -p 9200:9200 docker.io/saidsef/elasticsearch:latest
curl 'http://localhost:9200/_cat/health?v'
```

To deploy to Kubernetes from a clone of the repository:

```sh
kubectl create namespace elasticsearch
kubectl apply -n elasticsearch -k deployment/
```

## Documentation

[Read the Docs](https://elasticsearch-containerised.readthedocs.io/en/latest/) hosts the same pages.

| Page | Contents |
|------|----------|
| [Installation](./docs/installation.md) | Requirements, Docker, Kubernetes, health checks |
| [Configuration](./docs/configuration.md) | Image settings, StatefulSet settings, ports, probes, resources, storage, scheduling, security, plugins, metrics |
| [Versions](./docs/versions.md) | Elasticsearch version behind each image tag and git tag, and how CI tags images |
| [Upgrading](./docs/upgrading.md) | Upgrades from Elasticsearch 6.8, and the change of selector labels |

## Source

The latest source of *Elasticsearch - Containerised* is on [GitHub](https://github.com/saidsef/elasticsearch-containerised). [Fork us](https://github.com/saidsef/elasticsearch-containerised/fork)!

## Contributing

We would :heart:  you to contribute by making a [pull request](https://github.com/saidsef/elasticsearch-containerised/pulls).

Please read the official [Contribution Guide](./CONTRIBUTING.md) for more information on how you can contribute.
