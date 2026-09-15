# CEP-38: Try the CQL management API

```sh
docker run -it mmuzaf/cep-38
```

## Examples

One Cassandra node starts, you land in `cqlsh` connected to the management port, 11211, not the usual 9042.

```sql
INVOKE COMMAND status;
```

```sql
SELECT * FROM system_views.commands;
SELECT * FROM system_views.command_arguments WHERE command = 'compact'
```

```sql
INVOKE COMMAND "profile.start" WITH event = ['alloc'] AND duration = '5m' AND filename = 'memory-allocation-1.html';
docker cp $(docker ps -q --filter ancestor=mmuzaf/cep-38):/cassandra/memory-allocation-1.html .
```

A plain `INSERT` or `CREATE TABLE` doesn't work. The management port rejects it.

The image is built from [`Mmuzaf/cassandra@cassandra-19476-coc26`](https://github.com/Mmuzaf/cassandra/tree/cassandra-19476-coc26).

## Background reading

- the [CEP-38 design page](https://cwiki.apache.org/confluence/display/CASSANDRA/CEP-38%3A+CQL+Management+API)
- the implementation ticket [CASSANDRA-19476](https://issues.apache.org/jira/browse/CASSANDRA-19476)
