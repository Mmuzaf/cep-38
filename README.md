# CEP-38: Try the CQL management API

```sh
docker run -it --rm cep-38
```

The image is built from an experimental branch: [`Mmuzaf/cassandra@cassandra-19476-coc26`](https://github.com/Mmuzaf/cassandra/tree/cassandra-19476-coc26)

## Examples

One Cassandra node starts with a demo keyspace `ks` and table `ks.tbl` (three rows) created on the regular port, 9042.
You land in `cqlsh` connected to the management port, 11211.
The examples below are pre-loaded into the `cqlsh` history, press the Up arrow to recall them.

```sql
INVOKE COMMAND version;
INVOKE COMMAND status;
INVOKE COMMAND tpstats;
```

```sql
SELECT command FROM system_views.commands;
SELECT command, argument, arity, default_value, kind, required, type FROM system_views.command_arguments WHERE command = 'status';
```

```sql
INVOKE COMMAND "profile.start" WITH event = ['alloc'] AND duration = '10s' AND filename = 'alloc-profile-1.html';
```

The profile is written inside the container, copy it out:

```sh
docker cp $(docker ps -ql --filter status=running --filter ancestor=mmuzaf/cep-38):/cassandra/alloc-profile-1.html .
```

A plain `CREATE` or `INSERT` doesn't work. The management port rejects it, recall these from history to see for yourself:

```sql
CREATE KEYSPACE ks WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
CREATE TABLE ks.tbl (k text PRIMARY KEY, v int);
INSERT INTO ks.tbl (k, v) VALUES ('k1', 1);
```

## Custom commands

The image ships a new custom command, `memorybreakdown`, from the plugin directory [`examples/nodetool-custom-commands`](https://github.com/Mmuzaf/cassandra/tree/cassandra-19476-coc26/examples/nodetool-custom-commands).

Run it from `cqlsh`:

```sql
INVOKE COMMAND memorybreakdown;
```

To run it with `nodetool` either via JMX or CQL:

```sh
docker exec -it $(docker ps -ql --filter status=running --filter ancestor=cep-38) bash
cd /cassandra

bin/nodetool memorybreakdown
CASSANDRA_CLI_EXECUTION_PROTOCOL=cql bin/nodetool memorybreakdown
```

## Background reading

- the [CEP-38 design page](https://cwiki.apache.org/confluence/display/CASSANDRA/CEP-38%3A+CQL+Management+API)
- the implementation ticket [CASSANDRA-19476](https://issues.apache.org/jira/browse/CASSANDRA-19476)
- the pull request [apache/cassandra#4582](https://github.com/apache/cassandra/pull/4582)

## Author

Maxim Muzafarov, author of CEP-38. 
Find me on [LinkedIn](https://www.linkedin.com/in/mmuzaf/). 
Write to `mmuzaf at apache.org`.
