# Use a base Linux distribution
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget gnupg2 openjdk-11-jdk && \
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list' && \
    apt-get update && \
    apt-get install -y elasticsearch && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure Elasticsearch to allow remote connections (optional)
RUN echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml

# Expose the Elasticsearch port
EXPOSE 9200 9300

# Create a mount point for the data directory
VOLUME ["/usr/share/elasticsearch/data"]

# Set the entrypoint
ENTRYPOINT ["/usr/share/elasticsearch/bin/elasticsearch"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost:9200/_cluster/health || exit 1
