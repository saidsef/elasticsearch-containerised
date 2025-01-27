# https://www.elastic.co/guide/en/elasticsearch/reference/6.8/docker.html
FROM docker.elastic.co/elasticsearch/elasticsearch:8.17.1

LABEL org.opencontainers.image.authors="Said Sef <saidsef@gmail.com> (saidsef.co.uk)"
LABEL org.opencontainers.image.description="Elasticsearch 6.8 with plugins"
LABEL org.opencontainers.image.title="Elaticsearch 6.8 with plugins"
LABEL org.opencontainers.image.url="docker.io/saidsef/elasticsearch:latest"
LABEL org.opencontainers.image.documentation="https://www.elastic.co/guide/en/elasticsearch/reference/6.8/release-notes-6.8.0.html"

ENV bootstrap.memory_lock=true \
    cluster.name=spot \
    discovery.type=single-node \
    ES_JAVA_OPTS="-Xms1g -Xmx1g -XX:UseAVX=0" \
    http.compression_level=9 \
    http.compression=true \
    http.cors.enabled=true \
    node.ingest=true \
    node.name=ec2 \
    logger.discovery.level=warn \
    logger.deprecation.level=warn \
    xpack.graph.enabled=true \
    xpack.ml.enabled=true \
    xpack.monitoring.collection.enabled=true \
    xpack.monitoring.enabled=true \
    xpack.security.enabled=false \
    xpack.watcher.enabled=true \
    xpack.monitoring.exporters.default_local.type=local

RUN cd /usr/share/elasticsearch \
    && bin/elasticsearch-plugin install -b analysis-icu \
    && bin/elasticsearch-plugin install -b analysis-phonetic \
    && bin/elasticsearch-plugin install -b discovery-ec2 \
    && bin/elasticsearch-plugin install -b discovery-file \
    && bin/elasticsearch-plugin install -b ingest-attachment \
    && bin/elasticsearch-plugin install -b mapper-annotated-text \
    && bin/elasticsearch-plugin install -b mapper-murmur3 \
    && bin/elasticsearch-plugin install -b mapper-size \
    && bin/elasticsearch-plugin install -b repository-s3 \
    && bin/elasticsearch-plugin install -b repository-gcs

USER elasticsearch
