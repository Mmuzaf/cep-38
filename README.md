# CEP-38: Try the CQL management API

```sh
docker run -it mmuzaf/cep-38
```

## Examples

One Cassandra node starts, you land in `cqlsh` connected to the management port, 11211, not the usual 9042.

```sql
INVOKE COMMAND version;
INVOKE COMMAND status;
INVOKE COMMAND tpstats;
```

```sql
SELECT * FROM system_views.commands;
SELECT * FROM system_views.command_arguments WHERE command = 'status';
```

```sql
INVOKE COMMAND "profile.start" WITH event = ['alloc'] AND duration = '5m' AND filename = 'memory-allocation-1.html';
```

The profile is written inside the container, copy it out:

```sh
docker cp $(docker ps -q --filter ancestor=mmuzaf/cep-38):/cassandra/memory-allocation-1.html .
```

A plain `INSERT` or `CREATE TABLE` doesn't work. The management port rejects it.

The image is built from [`Mmuzaf/cassandra@cassandra-19476-coc26`](https://github.com/Mmuzaf/cassandra/tree/cassandra-19476-coc26).

## Background reading

- the [CEP-38 design page](https://cwiki.apache.org/confluence/display/CASSANDRA/CEP-38%3A+CQL+Management+API)
- the implementation ticket [CASSANDRA-19476](https://issues.apache.org/jira/browse/CASSANDRA-19476)
- the pull request [apache/cassandra#4582](https://github.com/apache/cassandra/pull/4582)

## Author

Maxim Muzafarov, author of CEP-38. 
Find me on [LinkedIn](https://www.linkedin.com/in/mmuzaf/). 
Write to `mmuzaf at apache.org`.
