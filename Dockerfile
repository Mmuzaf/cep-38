FROM eclipse-temurin:17-jdk AS build
ARG REPO=https://github.com/Mmuzaf/cassandra.git
ARG BRANCH=cassandra-19476-coc26
RUN apt-get update && apt-get install -y --no-install-recommends ant ant-optional git && rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 -b "$BRANCH" "$REPO" /src
WORKDIR /src
RUN ant artifacts -Dcheck.skip=true -Dant.gen-doc.skip=true

# cqlsh rejects the 3.14 in newer bases
FROM eclipse-temurin:17-jre-noble
RUN apt-get update && apt-get install -y --no-install-recommends python3 procps && rm -rf /var/lib/apt/lists/*
COPY --from=build /src/build/dist /cassandra
# Pre-seeded cqlsh history: Up arrow recalls the README examples without running them
COPY cqlsh_history /root/.cassandra/cqlsh_history
RUN mkdir -p /cassandra/logs && chmod +x /cassandra/bin/* /cassandra/tools/bin/* \
 && sed -i 's/^start_native_transport_management: false/start_native_transport_management: true/' /cassandra/conf/cassandra.yaml
ENV PATH=/cassandra/bin:$PATH \
    MAX_HEAP_SIZE=1G HEAP_NEWSIZE=256M \
    JVM_OPTS="-Dcassandra.skip_wait_for_gossip_to_settle=0 -Dcassandra.async_profiler.enabled=true"
CMD echo 'Starting a single Cassandra node with the management port (11211) enabled...'; \
    cassandra -R >/cassandra/logs/stdout.log 2>&1; \
    for i in $(seq 90); do \
      if cqlsh 127.0.0.1 11211 -e 'SELECT key FROM system.local' >/dev/null 2>&1; then \
        echo "Management port is up after ${i}s. Opening cqlsh; press Tab for completion, Up arrow for example commands."; exec cqlsh 127.0.0.1 11211; fi; \
      [ $((i % 5)) -eq 0 ] && echo "  ${i}s  $(tail -n 1 /cassandra/logs/system.log 2>/dev/null | cut -c1-140)"; \
      sleep 1; \
    done; \
    echo 'Node did not answer on 11211 within 90s. Last cqlsh error, then log tails:'; \
    cqlsh 127.0.0.1 11211 -e 'SELECT key FROM system.local'; \
    tail -n 40 /cassandra/logs/stdout.log /cassandra/logs/system.log; exit 1
