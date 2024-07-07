(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ psql -U postgres
Password for user postgres: 
psql (16.3 (Ubuntu 16.3-0ubuntu0.24.04.1))
Type "help" for help.

postgres=# \l
postgres=# \q
(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ psql -U commercedb
Password for user commercedb: 
psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL:  password authentication failed for user "commercedb"
(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ psql -U commercedb
Password for user commercedb: 
psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: fe_sendauth: no password supplied
(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ psql -U postgres
Password for user postgres: 
psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL:  password authentication failed for user "postgres"
(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ psql -U postgres
Password for user postgres: 
psql (16.3 (Ubuntu 16.3-0ubuntu0.24.04.1))
Type "help" for help.

postgres=# \l
                                                               List of databases
           Name           |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | ICU Locale | ICU Rules |   Access privileges   
--------------------------+----------+----------+-----------------+-------------+-------------+------------+-----------+-----------------------
 commercedb               | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           | 
 eric                     | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           | 
 postgres                 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           | 
 techBook_app_development | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           | 
 techBook_app_test        | ericsson | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           | 
 template0                | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           | =c/postgres          +
                          |          |          |                 |             |             |            |           | postgres=CTc/postgres
 template1                | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            |           | =c/postgres          +
                          |          |          |                 |             |             |            |           | postgres=CTc/postgres
(7 rows)

postgres=# ^C
postgres=# \q
(base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ psql -U postgres commercedb
Password for user postgres: 
psql (16.3 (Ubuntu 16.3-0ubuntu0.24.04.1))
Type "help" for help.

commercedb=# CREATE TABLE Customers (
    Customer_id SERIAL PRIMARY KEY,
    Customer_name VARCHAR(50),
    Contact_info TEXT,
    Customer_Address TEXT
);


-- Create Customers table sql commands

CREATE TABLE
commercedb=# \dt
           List of relations
 Schema |   Name    | Type  |  Owner   
--------+-----------+-------+----------
 public | customers | table | postgres
(1 row)

commercedb=# \d Customers
                                             Table "public.customers"
      Column      |         Type          | Collation | Nullable |                    Default                     
------------------+-----------------------+-----------+----------+------------------------------------------------
 customer_id      | integer               |           | not null | nextval('customers_customer_id_seq'::regclass)
 customer_name    | character varying(50) |           |          | 
 contact_info     | text                  |           |          | 
 customer_address | text                  |           |          | 
Indexes:
    "customers_pkey" PRIMARY KEY, btree (customer_id)

commercedb=# INSERT INTO Customers (Customer_name, Contact_info, Customer_address)
SELECT 
   md5(random()::text) AS Customer_name,
   md5(random()::text) AS Contact_info,
   md5(random()::text) AS Customer_address
FROM
   generate_sereis(1, 30000000);   
ERROR:  function generate_sereis(integer, integer) does not exist
LINE 7:    generate_sereis(1, 30000000);
           ^
HINT:  No function matches the given name and argument types. You might need to add explicit type casts.
commercedb=# INSERT INTO Customers (Customer_name, Contact_info, Customer_address)
SELECT 
   md5(random()::text) AS Customer_name,
   md5(random()::text) AS Contact_info,
   md5(random()::text) AS Customer_address
FROM
   generate_series(1, 30000000);
INSERT 0 30000000
commercedb=# 

commercedb=# SELECT COUNT(*) FROM Customers
commercedb-# SELECT COUNT(*) FROM Customers;
ERROR:  syntax error at or near "SELECT"
LINE 2: SELECT COUNT(*) FROM Customers;
        ^
commercedb=# SELECT COUNT(*) FROM Customers;
  count   
----------
 30000000
(1 row)

commercedb=# EXPLAIN SELECT COUNT(*) FROM Customers;
                                                         QUERY PLAN                                                         
----------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=636283.10..636283.11 rows=1 width=8)
   ->  Gather  (cost=636282.89..636283.10 rows=2 width=8)
         Workers Planned: 2
         ->  Partial Aggregate  (cost=635282.89..635282.90 rows=1 width=8)
               ->  Parallel Index Only Scan using customers_pkey on customers  (cost=0.44..604032.84 rows=12500018 width=0)
 JIT:
   Functions: 4
   Options: Inlining true, Optimization true, Expressions true, Deforming true
(8 rows)

commercedb=# 



--- Create Accounts table sql commands

base) ericsson@ericsson-HP-EliteBook-820-G3 ~$ psql -U postgres commercedb
Password for user postgres: 
psql (16.3 (Ubuntu 16.3-0ubuntu0.24.04.1))
Type "help" for help.

commercedb=# -- Drop the Accounts table if it already exists
DROP TABLE IF EXISTS Accounts;

-- Create the Accounts table
CREATE TABLE Accounts (
    Account_id SERIAL PRIMARY KEY,
    Balance NUMERIC(6, 2),
    Customer_id INT UNIQUE, -- Ensuring each Customer_id is unique
    FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);
NOTICE:  table "accounts" does not exist, skipping
DROP TABLE
CREATE TABLE
commercedb=# \dt
           List of relations
 Schema |   Name    | Type  |  Owner   
--------+-----------+-------+----------
 public | accounts  | table | postgres
 public | customers | table | postgres
(2 rows)

commercedb=# \d accounts
                                     Table "public.accounts"
   Column    |     Type     | Collation | Nullable |                   Default                    
-------------+--------------+-----------+----------+----------------------------------------------
 account_id  | integer      |           | not null | nextval('accounts_account_id_seq'::regclass)
 balance     | numeric(6,2) |           |          | 
 customer_id | integer      |           |          | 
Indexes:
    "accounts_pkey" PRIMARY KEY, btree (account_id)
    "accounts_customer_id_key" UNIQUE CONSTRAINT, btree (customer_id)
Foreign-key constraints:
    "accounts_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES customers(customer_id)

commercedb=# INSERT INTO Accounts (Balance, Customer_id)
SELECT
    (random() * 10000)::NUMERIC(6, 2) AS Balance,
    Customer_id
FROM
    Customers;
ERROR:  numeric field overflow
DETAIL:  A field with precision 6, scale 2 must round to an absolute value less than 10^4.
commercedb=# INSERT INTO Accounts (Balance, Customer_id)
SELECT
    (random() * 9999)::NUMERIC(6, 2) AS Balance,
    Customer_id
FROM
    Customers; 
INSERT 0 30000000
commercedb=# EXPLAIN ANALYZE SELECT COUNT(*) FROM Accounts;
                                                                    QUERY PLAN                                                                     
---------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=319414.03..319414.04 rows=1 width=8) (actual time=1659.013..1673.214 rows=1 loops=1)
   ->  Gather  (cost=319413.81..319414.02 rows=2 width=8) (actual time=1658.904..1673.185 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=318413.81..318413.82 rows=1 width=8) (actual time=1628.800..1628.801 rows=1 loops=3)
               ->  Parallel Seq Scan on accounts  (cost=0.00..287163.65 rows=12500065 width=0) (actual time=0.028..1051.371 rows=10000000 loops=3)
 Planning Time: 0.593 ms
 JIT:
   Functions: 8
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 1.242 ms, Inlining 0.000 ms, Optimization 0.943 ms, Emission 17.317 ms, Total 19.503 ms
 Execution Time: 1674.210 ms
(12 rows)

commercedb=# SELECT COUNT(*) FROM Accounts;
  count   
----------
 30000000
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT COUNT(*) FROM Accounts;
                                                                        QUERY PLAN                                                                        
----------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=319414.03..319414.04 rows=1 width=8) (actual time=1966.876..1974.202 rows=1 loops=1)
   Output: count(*)
   Buffers: shared hit=3781 read=158382
   ->  Gather  (cost=319413.81..319414.02 rows=2 width=8) (actual time=1966.682..1974.179 rows=3 loops=1)
         Output: (PARTIAL count(*))
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=3781 read=158382
         ->  Partial Aggregate  (cost=318413.81..318413.82 rows=1 width=8) (actual time=1888.485..1888.486 rows=1 loops=3)
               Output: PARTIAL count(*)
               Buffers: shared hit=3781 read=158382
               Worker 0:  actual time=1846.911..1846.911 rows=1 loops=1
                 JIT:
                   Functions: 2
                   Options: Inlining false, Optimization false, Expressions true, Deforming true
                   Timing: Generation 0.223 ms, Inlining 0.000 ms, Optimization 0.256 ms, Emission 6.332 ms, Total 6.811 ms
                 Buffers: shared hit=951 read=43042
               Worker 1:  actual time=1853.093..1853.094 rows=1 loops=1
                 JIT:
                   Functions: 2
                   Options: Inlining false, Optimization false, Expressions true, Deforming true
                   Timing: Generation 0.297 ms, Inlining 0.000 ms, Optimization 0.374 ms, Emission 4.652 ms, Total 5.322 ms
                 Buffers: shared hit=936 read=41907
               ->  Parallel Seq Scan on public.accounts  (cost=0.00..287163.65 rows=12500065 width=0) (actual time=0.086..1154.361 rows=10000000 loops=3)
                     Output: account_id, balance, customer_id
                     Buffers: shared hit=3781 read=158382
                     Worker 0:  actual time=0.045..1150.620 rows=8138705 loops=1
                       Buffers: shared hit=951 read=43042
                     Worker 1:  actual time=0.081..1155.664 rows=7925800 loops=1
                       Buffers: shared hit=936 read=41907
 Planning Time: 0.290 ms
 JIT:
   Functions: 8
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 1.833 ms, Inlining 0.000 ms, Optimization 1.465 ms, Emission 30.230 ms, Total 33.528 ms
 Execution Time: 1975.684 ms
(36 rows)

commercedb=# SELECT Balance FROM Accounts WHERE Account_id = 5;
 balance 
---------
(0 rows)

commercedb=# SELECT * FROM Accounts WHERE Account_id = 5;
 account_id | balance | customer_id 
------------+---------+-------------
(0 rows)

commercedb=# SELECct * FROM Accounts WHERE accound_id = 5;
ERROR:  syntax error at or near "SELECct"
LINE 1: SELECct * FROM Accounts WHERE accound_id = 5;
        ^
commercedb=# SELECT * FROM Accounts WHERE accound_id = 5;
ERROR:  column "accound_id" does not exist
LINE 1: SELECT * FROM Accounts WHERE accound_id = 5;
                                     ^
HINT:  Perhaps you meant to reference the column "accounts.account_id".
commercedb=# SELECT * FROM Accounts WHERE account_id = 5;
 account_id | balance | customer_id 
------------+---------+-------------
(0 rows)

commercedb=# SELECT MIN(account_id), MAX(account_id) FROM Accounts;
   min   |   max    
---------+----------
 1113444 | 31113443
(1 row)

commercedb=# SELECT * FROM Customers WHERE Customer_id = 1;
 customer_id |          customer_name           |           contact_info           |         customer_address         
-------------+----------------------------------+----------------------------------+----------------------------------
           1 | d51f855457b61ae5c0ccfc3ccfd54d2a | dd179d9c451f0d51d8445eaddd4b119e | 382d4bb29ae20f8856cc09168f35f044
(1 row)

commercedb=# SELECT last_value, start_value, increment_by, min_value, max_value, is_cycled
FROM accounts_account_id_seq;
ERROR:  column "start_value" does not exist
LINE 1: SELECT last_value, start_value, increment_by, min_value, max...
                           ^
HINT:  Perhaps you meant to reference the column "accounts_account_id_seq.last_value".
commercedb=# SELECT Account_id FROM Accounts ORDER BY Account_id LIMIT 10;
 account_id 
------------
    1113444
    1113445
    1113446
    1113447
    1113448
    1113449
    1113450
    1113451
    1113452
    1113453
(10 rows)

commercedb=# SELECT COUNT(*) FROM Accounts
commercedb-# ;
  count   
----------
 30000000
(1 row)

commercedb=# ALTER SEQUENCE accounts_account_id_seq RESTART with 1;
ALTER SEQUENCE
commercedb=# SELECT Account_id FROM Accounts ORDER BY Account_id LIMIT 10
commercedb-# ;
 account_id 
------------
    1113444
    1113445
    1113446
    1113447
    1113448
    1113449
    1113450
    1113451
    1113452
    1113453
(10 rows)

commercedb=# SELECT * FROM Accounts WHERE Customer_id = 1;
 account_id | balance | customer_id 
------------+---------+-------------
    1113444 | 5664.84 |           1
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT * FROM Accounts WHERE Customer_id = 1
commercedb-# ;
                                                                QUERY PLAN                                                                 
-------------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using accounts_customer_id_key on public.accounts  (cost=0.44..8.46 rows=1 width=14) (actual time=0.032..0.035 rows=1 loops=1)
   Output: account_id, balance, customer_id
   Index Cond: (accounts.customer_id = 1)
   Buffers: shared hit=4
 Planning Time: 0.129 ms
 Execution Time: 0.062 ms
(6 rows)

commercedb=# \d Accounts
                                     Table "public.accounts"
   Column    |     Type     | Collation | Nullable |                   Default                    
-------------+--------------+-----------+----------+----------------------------------------------
 account_id  | integer      |           | not null | nextval('accounts_account_id_seq'::regclass)
 balance     | numeric(6,2) |           |          | 
 customer_id | integer      |           |          | 
Indexes:
    "accounts_pkey" PRIMARY KEY, btree (account_id)
    "accounts_customer_id_key" UNIQUE CONSTRAINT, btree (customer_id)
Foreign-key constraints:
    "accounts_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES customers(customer_id)

commercedb=# SELECT Balance FROM Accounts WHERE Customer_id = 10;
 balance 
---------
 6875.78
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT Balance FROM Accounts WHERE Customer_id = 10;
                                                                QUERY PLAN                                                                
------------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using accounts_customer_id_key on public.accounts  (cost=0.44..8.46 rows=1 width=6) (actual time=0.034..0.037 rows=1 loops=1)
   Output: balance
   Index Cond: (accounts.customer_id = 10)
   Buffers: shared hit=4
 Planning Time: 0.126 ms
 Execution Time: 0.067 ms
(6 rows)




--- Create Suppliers table sql command


 ericsson@ericsson-HP-EliteBook-820-G3 ~$ psql -U postgres commercedb
Password for user postgres: 
psql (16.3 (Ubuntu 16.3-0ubuntu0.24.04.1))
Type "help" for help.

commercedb=# DROP TABLE IF EXISTS Suppliers;
NOTICE:  table "suppliers" does not exist, skipping
DROP TABLE
commercedb=# CREATE TABLE Suppliers (
    Supplier_id SERIAL PRIMARY KEY,
    Supplier_name VARCHAR(50) NOT NULL,
    Contact_info TEXT NOT NULL
);
CREATE TABLE
commercedb=# INSERT INTO Suppliers (Supplier_name, Contact_info)
SELECT 
   md5(random()::text) AS Supplier_name,
   md5(random()::text) AS Contact_info
FROM
   generate_series(1, 100000);
INSERT 0 100000
commercedb=# \dt
           List of relations
 Schema |   Name    | Type  |  Owner   
--------+-----------+-------+----------
 public | accounts  | table | postgres
 public | customers | table | postgres
 public | suppliers | table | postgres
(3 rows)

commercedb=# \d suppliers
                                           Table "public.suppliers"
    Column     |         Type          | Collation | Nullable |                    Default                     
---------------+-----------------------+-----------+----------+------------------------------------------------
 supplier_id   | integer               |           | not null | nextval('suppliers_supplier_id_seq'::regclass)
 supplier_name | character varying(50) |           | not null | 
 contact_info  | text                  |           | not null | 
Indexes:
    "suppliers_pkey" PRIMARY KEY, btree (supplier_id)

commercedb=# SELECT COUNT(*) FROM Suppliers;
 count  
--------
 100000
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT COUNT(*) FROM Suppliers; 
                                                          QUERY PLAN                                                          
------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2485.00..2485.01 rows=1 width=8) (actual time=82.173..82.175 rows=1 loops=1)
   Output: count(*)
   Buffers: shared hit=1235
   ->  Seq Scan on public.suppliers  (cost=0.00..2235.00 rows=100000 width=0) (actual time=0.028..43.934 rows=100000 loops=1)
         Output: supplier_id, supplier_name, contact_info
         Buffers: shared hit=1235
 Planning Time: 0.207 ms
 Execution Time: 82.243 ms
(8 rows)

commercedb=# SELECT MIN(supplier_id), MAX(supplier_id) FROM Suppliers;
 min |  max   
-----+--------
   1 | 100000
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT MIN(supplier_id), MAX(supplier_id) FROM Suppliers
commercedb-# ;
                                                                                   QUERY PLAN                                                                                    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Result  (cost=0.64..0.65 rows=1 width=8) (actual time=0.175..0.179 rows=1 loops=1)
   Output: $0, $1
   Buffers: shared hit=6
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.29..0.32 rows=1 width=4) (actual time=0.138..0.141 rows=1 loops=1)
           Output: suppliers.supplier_id
           Buffers: shared hit=3
           ->  Index Only Scan using suppliers_pkey on public.suppliers  (cost=0.29..2854.29 rows=100000 width=4) (actual time=0.136..0.136 rows=1 loops=1)
                 Output: suppliers.supplier_id
                 Index Cond: (suppliers.supplier_id IS NOT NULL)
                 Heap Fetches: 0
                 Buffers: shared hit=3
   InitPlan 2 (returns $1)
     ->  Limit  (cost=0.29..0.32 rows=1 width=4) (actual time=0.026..0.027 rows=1 loops=1)
           Output: suppliers_1.supplier_id
           Buffers: shared hit=3
           ->  Index Only Scan Backward using suppliers_pkey on public.suppliers suppliers_1  (cost=0.29..2854.29 rows=100000 width=4) (actual time=0.025..0.025 rows=1 loops=1)
                 Output: suppliers_1.supplier_id
                 Index Cond: (suppliers_1.supplier_id IS NOT NULL)
                 Heap Fetches: 0
                 Buffers: shared hit=3
 Planning Time: 0.476 ms
 Execution Time: 0.236 ms
(23 rows)

commercedb=# SELECT Supplier_name FROM Suppliers ORDER BY supplier_id LIMIT 10;
          supplier_name           
----------------------------------
 0202521e5b58ac90e003a8d0025621c4
 9311b5ac5688a6693c9173ee1c253a67
 109fee4667b6be6b8697bd33f87d3a17
 d44f1b20b3b6186abc602378cb584f17
 e95554db2c231c0e78f28d967fec20da
 8eb3144d1a8c6c684c60481f54ab88a9
 dc12d5e94a3d8ac615f7725cc504bb2f
 daf76a9318083168b514254b03bb2d11
 646322657772745468e2f9d5fd64db35
 ac7f504d4c38dc87f9a19099c6684710
(10 rows)

commercedb=# SELECT * FROM Suppliers ORDER BY supplier_id LIMIT 10;
 supplier_id |          supplier_name           |           contact_info           
-------------+----------------------------------+----------------------------------
           1 | 0202521e5b58ac90e003a8d0025621c4 | 09777d74a1862be32478f20465f2e913
           2 | 9311b5ac5688a6693c9173ee1c253a67 | 96144e4620a1ad5025ba34f973fd20fc
           3 | 109fee4667b6be6b8697bd33f87d3a17 | 5d1bdf2d44cf659865bf3e84c2bd80d6
           4 | d44f1b20b3b6186abc602378cb584f17 | 654c39058ad0cf111edaeb88c4dc1d23
           5 | e95554db2c231c0e78f28d967fec20da | 1f116a8dcd2341cdd2b1d41eb5903a4b
           6 | 8eb3144d1a8c6c684c60481f54ab88a9 | 05bdd3eb84d75019bf6472d7864535d0
           7 | dc12d5e94a3d8ac615f7725cc504bb2f | bc220a9586bf7252eab9fa95dcdf264d
           8 | daf76a9318083168b514254b03bb2d11 | d98ecf88fb627de217570d7608a95dea
           9 | 646322657772745468e2f9d5fd64db35 | cfbaa0e4c31d25ddff8b2fd71ccf4bd3
          10 | ac7f504d4c38dc87f9a19099c6684710 | bcac15106472df1de00e2eb0a5af9144
(10 rows)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT * FROM Suppliers ORDER BY supplier_id LIMIT 10;
                                                                   QUERY PLAN                                                                    
-------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.29..0.68 rows=10 width=70) (actual time=0.019..0.024 rows=10 loops=1)
   Output: supplier_id, supplier_name, contact_info
   Buffers: shared hit=3
   ->  Index Scan using suppliers_pkey on public.suppliers  (cost=0.29..3842.29 rows=100000 width=70) (actual time=0.018..0.021 rows=10 loops=1)
         Output: supplier_id, supplier_name, contact_info
         Buffers: shared hit=3
 Planning Time: 0.066 ms
 Execution Time: 0.040 ms
(8 rows)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT supplier_id, supplier_name, contact_info FROM Suppliers ORDER BY supplier_id LIMIT 10;
                                                                   QUERY PLAN                                                                    
-------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.29..0.68 rows=10 width=70) (actual time=0.055..0.072 rows=10 loops=1)
   Output: supplier_id, supplier_name, contact_info
   Buffers: shared hit=3
   ->  Index Scan using suppliers_pkey on public.suppliers  (cost=0.29..3842.29 rows=100000 width=70) (actual time=0.052..0.063 rows=10 loops=1)
         Output: supplier_id, supplier_name, contact_info
         Buffers: shared hit=3
 Planning Time: 0.185 ms
 Execution Time: 0.111 ms
(8 rows)





