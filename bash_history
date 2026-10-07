CASSANDRA_CLI_EXECUTION_PROTOCOL=cql bin/nodetool memorybreakdown
iptables -A OUTPUT -o lo -p tcp --dport 7199 -j REJECT --reject-with tcp-reset
bin/nodetool memorybreakdown
