CREATE KEYSPACE IF NOT EXISTS ks WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
CREATE TABLE IF NOT EXISTS ks.tbl (k text PRIMARY KEY, v int);
INSERT INTO ks.tbl (k, v) VALUES ('k1', 1);
INSERT INTO ks.tbl (k, v) VALUES ('k2', 2);
INSERT INTO ks.tbl (k, v) VALUES ('k3', 3);
