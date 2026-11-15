# Configuration

The image and the StatefulSet configure Elasticsearch through environment variables. Elasticsearch reads each variable whose name contains a dot, such as `cluster.name`, as the setting of the same name, and refuses to start when the variable names a setting it does not know.

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
| `xpack.monitoring.exporters.default_local.type` | `local` |

With `discovery.type` set to `single-node`, the node elects itself master and does not join any other node. The image does not set `http.cors.allow-origin`. Elasticsearch answers status 403 to a request whose `Origin` header names another site, such as `http://example.com`. [Security](#security) describes the effect of `xpack.security.enabled`.

## StatefulSet settings

[`deployment/statefulset.yml`](https://github.com/saidsef/elasticsearch-containerised/blob/main/deployment/statefulset.yml) adds these variables to the container:

| Variable | Value |
|---|---|
| `network.publish_host` | The pod IP, from `status.podIP` |
| `ES_JAVA_OPTS` | `-Xms1g -Xmx1g -XX:UseAVX=0` |
| `node.processors` | `1` |
| `bootstrap.memory_lock` | `false` |
| `xpack.ml.enabled` | `false` |
| `xpack.monitoring.collection.enabled` | `false` |
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

Kubernetes deletes an `emptyDir` volume with its pod. The data survives a container restart, but not the deletion or rescheduling of the pod. The kubelet evicts the pod when the volume grows past its size limit.

## Shutdown

Before Kubernetes stops the container, a `preStop` hook runs `curl -XPOST http://127.0.0.1:9200/_flush`, which asks Elasticsearch to flush every index to disk. The pod has 60 seconds from the start of termination to stop, and the hook counts towards that time.

## Scheduling

- The CI workflow builds the image for `linux/amd64` only. The StatefulSet prefers `amd64` nodes but does not require them.
- The StatefulSet does not set `replicas` and runs one pod. Every pod runs with `discovery.type` set to `single-node`, and a second replica would start a separate one-node cluster instead of joining the first.

## Security

- With `xpack.security.enabled` set to `false`, Elasticsearch accepts requests without authentication and serves HTTP without TLS.
- The Service has type `ClusterIP`, which makes it reachable from inside the cluster only.
- The pod runs as user and group 1000 without privilege escalation, drops every Linux capability and uses the `RuntimeDefault` seccomp profile. It does not mount a service account token.

## Plugins

The image does not install any plugins. Elasticsearch 9 ships the S3 and GCS snapshot repositories and the attachment processor as built-in modules.

## Metrics

The image does not expose Prometheus metrics. The [`jmx_prometheus_javaagent`](https://github.com/prometheus/jmx_exporter) 1.6.0 fails on Elasticsearch 9.5.5 with `NoClassDefFoundError: com/sun/net/httpserver/Authenticator`, and the node does not start.
