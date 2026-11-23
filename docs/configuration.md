# Configuration

The image and the StatefulSet configure Elasticsearch through environment variables. Elasticsearch reads each variable whose name contains a dot, such as `cluster.name`, as the setting of the same name, and refuses to start when the variable names an unknown setting.

## Image settings

The [Dockerfile](https://github.com/saidsef/elasticsearch-containerised/blob/main/Dockerfile) starts from Elastic's official image and sets:

| Setting | Value |
|---|---|
| `cluster.name` | `spot` |
| `node.name` | `ec2` |
| `discovery.type` | `single-node` |
| `http.compression` | `true` |
| `http.compression_level` | `9` |
| `http.cors.enabled` | `true` |
| `logger.discovery.level` | `warn` |
| `logger.deprecation.level` | `warn` |
| `xpack.graph.enabled` | `true` |
| `xpack.security.enabled` | `false` |
| `xpack.watcher.enabled` | `true` |

With `discovery.type` set to `single-node`, the node elects itself master and forms a cluster of one. `http.cors.allow-origin` keeps its empty default. Elasticsearch answers status 403 to a request whose `Origin` header names another site, such as `http://example.com`. [Security](#security) describes the effect of `xpack.security.enabled`.

## StatefulSet settings

[`deployment/statefulset.yml`](https://github.com/saidsef/elasticsearch-containerised/blob/main/deployment/statefulset.yml) adds these variables to the container:

| Variable | Value |
|---|---|
| `network.publish_host` | The pod IP, from `status.podIP` |
| `ES_JAVA_OPTS` | `-Xms1g -Xmx1g -XX:UseAVX=0` |
| `node.processors` | `1` |
| `bootstrap.memory_lock` | `false` |
| `xpack.ml.enabled` | `false` |
| `action.destructive_requires_name` | `true` |
| `indices.fielddata.cache.size` | `20%` |

`ES_JAVA_OPTS` fixes the minimum and maximum heap size, and turns off the JVM's use of AVX instructions.

## Ports

| Port | Service port name | Purpose |
|---|---|---|
| 9200 | `http-elasticsearch` | REST API over HTTP |
| 9300 | `tcp-cluster` | Transport protocol between nodes |

The Service has type `ClusterIP` and the `PreferDualStack` IP family policy. On a dual-stack cluster, it receives an IPv6 address as well as an IPv4 address.

## Probes

| Probe | Check | Period | Failure threshold |
|---|---|---|---|
| Startup | TCP connection to port 9200 | 10 seconds | 60 |
| Liveness | TCP connection to port 9200 | 10 seconds | 3 |
| Readiness | HTTP `GET` on `_cat/health` | 10 seconds | 3 |

Kubernetes runs the liveness and readiness probes only after the startup probe passes.

## Resources

| Resource | Request | Limit |
|---|---|---|
| Memory | `2Gi` | `2Gi` |
| CPU | `100m` | `300m` |

## Storage

Each pod has one `emptyDir` volume with a size limit of `3Gi`. The container mounts its `data` subdirectory at `/usr/share/elasticsearch/data` and its `tmp` subdirectory at `/tmp`.

Kubernetes deletes an `emptyDir` volume when it deletes or reschedules the pod. The data survives a container restart. The kubelet evicts the pod when the volume grows past its size limit.

## Shutdown

Before Kubernetes stops the container, a `preStop` hook runs `curl -XPOST http://127.0.0.1:9200/_flush`, which asks Elasticsearch to flush every index to disk. The pod has 60 seconds from the start of termination to stop, and the hook counts towards that time.

## Scheduling

- The CI workflow builds the image for `linux/amd64` only. The StatefulSet prefers `amd64` nodes and accepts nodes of other architectures.
- The StatefulSet runs one pod, the Kubernetes default for `replicas`. Every pod runs with `discovery.type` set to `single-node`. A second replica would start a separate one-node cluster.

## Security

- With `xpack.security.enabled` set to `false`, Elasticsearch accepts anonymous requests and serves plain HTTP.
- The Service has type `ClusterIP`, which makes it reachable from inside the cluster only.
- The pod runs as user and group 1000 with the `RuntimeDefault` seccomp profile, and sets `automountServiceAccountToken` to `false`.
- The container drops every Linux capability and sets `allowPrivilegeEscalation` to `false`.

## Plugins

The image relies on the modules built into Elasticsearch 9. They include the S3 and GCS snapshot repositories and the attachment processor.

## Metrics

Elasticsearch reports metrics through its REST APIs, such as `_nodes/stats`.
