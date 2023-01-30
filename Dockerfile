# https://www.elastic.co/guide/en/elasticsearch/reference/6.8/docker.html
FROM docker.elastic.co/elasticsearch/elasticsearch:8.6.1

LABEL maintainer="Said Sef <saidsef@gmail.com> (saidsef.co.uk)"
LABEL description="Elasticsearch with plugins"

ENV bootstrap.memory_lock=true
ENV cluster.name=spot
ENV discovery.type=single-node
ENV ES_JAVA_OPTS="-Xms3g -Xmx3g -XX:UseAVX=0"
ENV http.compression_level=9
ENV http.compression=true
ENV http.cors.enabled=true
ENV node.ingest=true
ENV node.name=ec2
ENV logger.discovery.level=warn
ENV logger.deprecation.level=warn
ENV xpack.graph.enabled=true
ENV xpack.ml.enabled=true
ENV xpack.monitoring.collection.enabled=true
ENV xpack.monitoring.enabled=true
ENV xpack.security.enabled=false
ENV xpack.watcher.enabled=true
ENV xpack.monitoring.exporters.default_local.type=local

RUN cd /usr/share/elasticsearch \
    && bin/elasticsearch-plugin install -b analysis-icu \
    && bin/elasticsearch-plugin install -b analysis-phonetic \
    && bin/elasticsearch-plugin install -b discovery-ec2 \
    && bin/elasticsearch-plugin install -b discovery-file \
    && bin/elasticsearch-plugin install -b ingest-attachment \
    && bin/elasticsearch-plugin install -b mapper-annotated-text \
    && bin/elasticsearch-plugin install -b mapper-murmur3 \
    && bin/elasticsearch-plugin install -b mapper-size \
    && bin/elasticsearch-plugin install -b repository-s3

USER elasticsearch
