# syntax=docker/dockerfile:1
# https://www.elastic.co/guide/en/elasticsearch/reference/6.8/docker.html
FROM docker.elastic.co/elasticsearch/elasticsearch:6.8.23

LABEL org.opencontainers.image.authors="Said Sef <saidsef@gmail.com> (saidsef.co.uk)"
LABEL org.opencontainers.image.description="Elasticsearch 6.8 with plugins"
LABEL org.opencontainers.image.title="Elasticsearch 6.8 with plugins"
LABEL org.opencontainers.image.url="https://github.com/saidsef/elasticsearch-containerised"
LABEL org.opencontainers.image.source="https://github.com/saidsef/elasticsearch-containerised"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.documentation="https://www.elastic.co/guide/en/elasticsearch/reference/6.8/release-notes-6.8.0.html"

ARG JMX_EXPORTER_VERSION=1.6.0
ARG JMX_EXPORTER_SHA256=a95983fd96e865d2bcdf911cc500e7c82808c27ab9fd226bf96732b6c3d8c46e

ENV cluster.name=spot \
    discovery.type=single-node \
    http.compression_level=9 \
    http.compression=true \
    http.cors.enabled=true \
    node.ingest=true \
    node.name=ec2 \
    logger.discovery.level=warn \
    logger.deprecation.level=warn \
    xpack.graph.enabled=true \
    xpack.monitoring.enabled=true \
    xpack.security.enabled=false \
    xpack.watcher.enabled=true \
    xpack.monitoring.exporters.default_local.type=local

RUN cd /usr/share/elasticsearch \
    && bin/elasticsearch-plugin install -b analysis-icu \
    && bin/elasticsearch-plugin install -b analysis-phonetic \
    && bin/elasticsearch-plugin install -b ingest-attachment \
    && bin/elasticsearch-plugin install -b mapper-annotated-text \
    && bin/elasticsearch-plugin install -b mapper-murmur3 \
    && bin/elasticsearch-plugin install -b mapper-size \
    && bin/elasticsearch-plugin install -b repository-s3 \
    && bin/elasticsearch-plugin install -b repository-gcs

ADD --checksum=sha256:${JMX_EXPORTER_SHA256} --chown=1000:0 --chmod=0644 \
    https://github.com/prometheus/jmx_exporter/releases/download/${JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar \
    /usr/share/elasticsearch/jmx_prometheus_javaagent.jar

COPY --chown=1000:0 conf/jvm.options /usr/share/elasticsearch/config/jvm.options
COPY --chown=1000:0 conf/prometheus-jmx-config.yaml /usr/share/elasticsearch/config/prometheus-jmx-config.yaml
COPY --chown=1000:0 conf/prometheus-jmx.policy /usr/share/elasticsearch/config/prometheus-jmx.policy

EXPOSE 9404

USER elasticsearch
