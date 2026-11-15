# syntax=docker/dockerfile:1
# https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-with-docker
FROM docker.elastic.co/elasticsearch/elasticsearch:9.5.5

LABEL org.opencontainers.image.authors="Said Sef <saidsef@gmail.com> (saidsef.co.uk)"
LABEL org.opencontainers.image.description="Elasticsearch 9.5 single node"
LABEL org.opencontainers.image.title="Elasticsearch 9.5"
LABEL org.opencontainers.image.url="https://github.com/saidsef/elasticsearch-containerised"
LABEL org.opencontainers.image.source="https://github.com/saidsef/elasticsearch-containerised"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.documentation="https://www.elastic.co/docs/release-notes/elasticsearch"

ENV cluster.name=spot \
    discovery.type=single-node \
    http.compression_level=9 \
    http.compression=true \
    http.cors.enabled=true \
    node.name=ec2 \
    logger.discovery.level=warn \
    logger.deprecation.level=warn \
    xpack.graph.enabled=true \
    xpack.security.enabled=false \
    xpack.watcher.enabled=true \
    xpack.monitoring.exporters.default_local.type=local

USER elasticsearch
