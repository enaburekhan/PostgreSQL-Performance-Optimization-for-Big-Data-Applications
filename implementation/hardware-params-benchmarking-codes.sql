(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ pgbench -i -s 100 commercedb
Password: 
dropping old tables...
NOTICE:  table "pgbench_accounts" does not exist, skipping
NOTICE:  table "pgbench_branches" does not exist, skipping
NOTICE:  table "pgbench_history" does not exist, skipping
NOTICE:  table "pgbench_tellers" does not exist, skipping
creating tables...
generating data (client-side)...
10000000 of 10000000 tuples (100%) done (elapsed 12.89 s, remaining 0.00 s)
vacuuming...
creating primary keys...
done in 20.31 s (drop tables 0.00 s, create tables 0.02 s, client-side generate 13.04 s, vacuum 0.83 s, primary keys 6.42 s).


(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ pgbench -c 10 -j 2 -T 60 commercedb
Password: 
pgbench (16.3 (Ubuntu 16.3-0ubuntu0.24.04.1))
starting vacuum...end.
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 10
number of threads: 2
maximum number of tries: 1
duration: 60 s
number of transactions actually processed: 166513
number of failed transactions: 0 (0.000%)
latency average = 3.602 ms
initial connection time = 76.093 ms
tps = 2776.555985 (without initial connection time)


(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ pgbench -c 10 -j 2 -T 60 commercedb
Password: 
pgbench (16.3 (Ubuntu 16.3-0ubuntu0.24.04.1))
starting vacuum...end.
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 10
number of threads: 2
maximum number of tries: 1
duration: 60 s
number of transactions actually processed: 48688
number of failed transactions: 0 (0.000%)
latency average = 12.308 ms
initial connection time = 98.411 ms
tps = 812.484656 (without initial connection time)


(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ pgbench -c 10 -j 2 -T 60 commercedb
Password: 
pgbench (16.3 (Ubuntu 16.3-0ubuntu0.24.04.1))
starting vacuum...end.
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 10
number of threads: 2
maximum number of tries: 1
duration: 60 s
number of transactions actually processed: 69694
number of failed transactions: 0 (0.000%)
latency average = 8.597 ms
initial connection time = 99.982 ms
tps = 1163.229736 (without initial connection time)


(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ sudo systemctl restart postgresql


---After Tuning the PostgreSQL Configuration Parameters

(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ pgbench -c 10 -j 2 -T 60 commercedb
Password: 
pgbench (16.3 (Ubuntu 16.3-0ubuntu0.24.04.1))
starting vacuum...end.
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 10
number of threads: 2
maximum number of tries: 1
duration: 60 s
number of transactions actually processed: 82121
number of failed transactions: 0 (0.000%)
latency average = 7.296 ms
initial connection time = 110.801 ms
tps = 1370.619997 (without initial connection time)


(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ pgbench -c 10 -j 2 -T 60 commercedb
Password: 
pgbench (16.3 (Ubuntu 16.3-0ubuntu0.24.04.1))
starting vacuum...end.
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 10
number of threads: 2
maximum number of tries: 1
duration: 60 s
number of transactions actually processed: 125643
number of failed transactions: 0 (0.000%)
latency average = 4.771 ms
initial connection time = 72.806 ms
tps = 2096.092572 (without initial connection time)


(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ pgbench -c 10 -j 2 -T 60 commercedb
Password: 
pgbench (16.3 (Ubuntu 16.3-0ubuntu0.24.04.1))
starting vacuum...end.
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 10
number of threads: 2
maximum number of tries: 1
duration: 60 s
number of transactions actually processed: 139848
number of failed transactions: 0 (0.000%)
latency average = 4.285 ms
initial connection time = 87.208 ms
tps = 2333.976659 (without initial connection time)

