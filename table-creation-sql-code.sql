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




--- Products table sql code during creation
commercedb=# DROP TABLE IF EXISTS Products;
NOTICE:  table "products" does not exist, skipping
DROP TABLE
commercedb=# CREATE TABLE Products (
    Product_id SERIAL PRIMARY KEY,
    Supplier_id INT NOT NULL,
    Product_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (Supplier_id) REFERENCES Suppliers(supplier_id)
);
CREATE TABLE
commercedb=# \dt
           List of relations
 Schema |   Name    | Type  |  Owner   
--------+-----------+-------+----------
 public | accounts  | table | postgres
 public | customers | table | postgres
 public | products  | table | postgres
 public | suppliers | table | postgres
(4 rows)

commercedb=# \d products
                                           Table "public.products"
    Column    |          Type          | Collation | Nullable |                   Default                    
--------------+------------------------+-----------+----------+----------------------------------------------
 product_id   | integer                |           | not null | nextval('products_product_id_seq'::regclass)
 supplier_id  | integer                |           | not null | 
 product_name | character varying(100) |           | not null | 
Indexes:
    "products_pkey" PRIMARY KEY, btree (product_id)
Foreign-key constraints:
    "products_supplier_id_fkey" FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)

commercedb=# INSERT INTO Products (Supplier_id, Product_name)
SELECT
    (random() * 100000)::INT + 1,                              
    md5(random()::text) AS Product_name
FROM generate_sereis(1, 10000000)
commercedb-# ;
ERROR:  function generate_sereis(integer, integer) does not exist
LINE 5: FROM generate_sereis(1, 10000000)
             ^
HINT:  No function matches the given name and argument types. You might need to add explicit type casts.
commercedb=# INSERT INTO Products (Supplier_id, Product_name)
SELECT
    (random() * 100000)::INT + 1, 
    md5(random()::text) AS Product_name
FROM generate_series(1, 10000000)
;
ERROR:  insert or update on table "products" violates foreign key constraint "products_supplier_id_fkey"
DETAIL:  Key (supplier_id)=(100001) is not present in table "suppliers".
commercedb=# INSERT INTO Products (Supplier_id, Product_name)
SELECT
    (random() * (SELECT MAX(Supplier_id) FROM Suppliers))::INT + 1, 
    md5(random()::text) AS Product_name
FROM 
   generate_series(1, 10000000);
ERROR:  insert or update on table "products" violates foreign key constraint "products_supplier_id_fkey"
DETAIL:  Key (supplier_id)=(100001) is not present in table "suppliers".
commercedb=# INSERT INTO Products (Supplier_id, Product_name)
SELECT
    width_bucket(random(), 0, 1, (SELECT MAX(Supplier_id) FROM Suppliers)), 
    md5(random()::text) AS Product_name
FROM 
   generate_series(1, 10000000); 
INSERT 0 10000000
commercedb=# SELECT COUNT(*) FROM Products;
  count   
----------
 10000000
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT COUNT(*) FROM Products;
                                                                      QUERY PLAN                                                                       
-------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=146541.58..146541.59 rows=1 width=8) (actual time=768.671..776.626 rows=1 loops=1)
   Output: count(*)
   Buffers: shared hit=14504 read=78954
   ->  Gather  (cost=146541.36..146541.57 rows=2 width=8) (actual time=768.487..776.591 rows=3 loops=1)
         Output: (PARTIAL count(*))
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=14504 read=78954
         ->  Partial Aggregate  (cost=145541.36..145541.37 rows=1 width=8) (actual time=698.789..698.790 rows=1 loops=3)
               Output: PARTIAL count(*)
               Buffers: shared hit=14504 read=78954
               Worker 0:  actual time=661.795..661.797 rows=1 loops=1
                 JIT:
                   Functions: 2
                   Options: Inlining false, Optimization false, Expressions true, Deforming true
                   Timing: Generation 0.252 ms, Inlining 0.000 ms, Optimization 0.309 ms, Emission 4.651 ms, Total 5.213 ms
                 Buffers: shared hit=3602 read=20728
               Worker 1:  actual time=666.789..666.791 rows=1 loops=1
                 JIT:
                   Functions: 2
                   Options: Inlining false, Optimization false, Expressions true, Deforming true
                   Timing: Generation 0.262 ms, Inlining 0.000 ms, Optimization 0.314 ms, Emission 4.970 ms, Total 5.545 ms
                 Buffers: shared hit=3736 read=21545
               ->  Parallel Seq Scan on public.products  (cost=0.00..135124.69 rows=4166669 width=0) (actual time=0.057..439.646 rows=3333333 loops=3)
                     Output: product_id, supplier_id, product_name
                     Buffers: shared hit=14504 read=78954
                     Worker 0:  actual time=0.059..426.318 rows=2603310 loops=1
                       Buffers: shared hit=3602 read=20728
                     Worker 1:  actual time=0.051..429.283 rows=2705067 loops=1
                       Buffers: shared hit=3736 read=21545
 Planning:
   Buffers: shared hit=14
 Planning Time: 0.466 ms
 JIT:
   Functions: 8
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 1.286 ms, Inlining 0.000 ms, Optimization 1.118 ms, Emission 30.569 ms, Total 32.973 ms
 Execution Time: 777.507 ms
(38 rows)

commercedb=# SELECT * FROM Products ORDER BY product_id LIMIT 10;
 product_id | supplier_id |           product_name           
------------+-------------+----------------------------------
   20000001 |       92685 | 317079f7fe0b81744dd84d57b93cd5c3
   20000002 |       11560 | fba54e7fc8f2224589ccee2485ae4246
   20000003 |       58539 | a3f3e90a11aec0575539bc054e553f0a
   20000004 |       40119 | bba7bf403fb02a42b68e1b96daee5061
   20000005 |       51047 | f2c5b79271e521e0fc888c8c8b12e1c0
   20000006 |       34495 | ef1697ae7cdd474c278a0beb3c8fd9b0
   20000007 |        4958 | 213c79ba1f9f8f3e4147c66ff8cc5225
   20000008 |       38458 | aeb033ecf62216c8b9ec9c7b3a30ccb2
   20000009 |       18535 | 206e5ce626cd8656c6141d67a07d2908
   20000010 |       76181 | 57d4185164f0f768688fd54d7c6d086b
(10 rows)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT * FROM Products ORDER BY product_id LIMIT 10;
                                                                    QUERY PLAN                                                                     
---------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.43..0.90 rows=10 width=41) (actual time=0.102..0.125 rows=10 loops=1)
   Output: product_id, supplier_id, product_name
   Buffers: shared hit=4
   ->  Index Scan using products_pkey on public.products  (cost=0.43..462813.53 rows=10000006 width=41) (actual time=0.096..0.111 rows=10 loops=1)
         Output: product_id, supplier_id, product_name
         Buffers: shared hit=4
 Planning Time: 0.379 ms
 Execution Time: 0.195 ms
(8 rows)

commercedb=# SELECT MIN(Product_id), MAX(product_id) FROM Products;
   min    |   max    
----------+----------
 20000001 | 30000000
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT MIN(Product_id), MAX(product_id) FROM Products;
                                                                                    QUERY PLAN                                                                                    
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Result  (cost=0.95..0.96 rows=1 width=8) (actual time=0.074..0.076 rows=1 loops=1)
   Output: $0, $1
   Buffers: shared hit=8
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.43..0.47 rows=1 width=4) (actual time=0.047..0.048 rows=1 loops=1)
           Output: products.product_id
           Buffers: shared hit=4
           ->  Index Only Scan using products_pkey on public.products  (cost=0.43..394352.54 rows=10000006 width=4) (actual time=0.045..0.046 rows=1 loops=1)
                 Output: products.product_id
                 Index Cond: (products.product_id IS NOT NULL)
                 Heap Fetches: 0
                 Buffers: shared hit=4
   InitPlan 2 (returns $1)
     ->  Limit  (cost=0.43..0.47 rows=1 width=4) (actual time=0.021..0.021 rows=1 loops=1)
           Output: products_1.product_id
           Buffers: shared hit=4
           ->  Index Only Scan Backward using products_pkey on public.products products_1  (cost=0.43..394352.54 rows=10000006 width=4) (actual time=0.020..0.020 rows=1 loops=1)
                 Output: products_1.product_id
                 Index Cond: (products_1.product_id IS NOT NULL)
                 Heap Fetches: 0
                 Buffers: shared hit=4
 Planning Time: 0.187 ms
 Execution Time: 0.110 ms
(23 rows)




--- SQL Code for Prices table creation

commercedb=# DROP TABLE IF EXISTS Prices;
NOTICE:  table "prices" does not exist, skipping
DROP TABLE
commercedb=# CREATE TABLE Prices (
    Price_id SERIAL PRIMARY KEY,
    Product_id INT NOT NULL,
    Price NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (Product_id) REFERENCES Products(Product_id)
);
CREATE TABLE
commercedb=# \dt
           List of relations
 Schema |   Name    | Type  |  Owner   
--------+-----------+-------+----------
 public | accounts  | table | postgres
 public | customers | table | postgres
 public | prices    | table | postgres
 public | products  | table | postgres
 public | suppliers | table | postgres
(5 rows)

commercedb=# \d prices
                                    Table "public.prices"
   Column   |     Type      | Collation | Nullable |                 Default                  
------------+---------------+-----------+----------+------------------------------------------
 price_id   | integer       |           | not null | nextval('prices_price_id_seq'::regclass)
 product_id | integer       |           | not null | 
 price      | numeric(10,2) |           | not null | 
Indexes:
    "prices_pkey" PRIMARY KEY, btree (price_id)
Foreign-key constraints:
    "prices_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(product_id)

commercedb=# INSERT INTO Prices (Product_id, Price)
SELECT
    Product_id,
    (random() * 1000)::NUMERIC(10, 2) AS Price    
FROM Products;
INSERT 0 10000000
commercedb=# SELECT COUNT(*) FROM Prices;
  count   
----------
 10000000
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT COUNT(*) FROM Prices;
                                                                     QUERY PLAN                                                                     
----------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=107139.46..107139.47 rows=1 width=8) (actual time=1129.241..1136.753 rows=1 loops=1)
   Output: count(*)
   Buffers: shared hit=5147 read=48908
   ->  Gather  (cost=107139.25..107139.46 rows=2 width=8) (actual time=1129.090..1136.723 rows=3 loops=1)
         Output: (PARTIAL count(*))
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=5147 read=48908
         ->  Partial Aggregate  (cost=106139.25..106139.26 rows=1 width=8) (actual time=1022.599..1022.600 rows=1 loops=3)
               Output: PARTIAL count(*)
               Buffers: shared hit=5147 read=48908
               Worker 0:  actual time=961.966..961.967 rows=1 loops=1
                 JIT:
                   Functions: 2
                   Options: Inlining false, Optimization false, Expressions true, Deforming true
                   Timing: Generation 0.983 ms, Inlining 0.000 ms, Optimization 0.984 ms, Emission 20.509 ms, Total 22.476 ms
                 Buffers: shared hit=1338 read=13024
               Worker 1:  actual time=977.744..977.745 rows=1 loops=1
                 JIT:
                   Functions: 2
                   Options: Inlining false, Optimization false, Expressions true, Deforming true
                   Timing: Generation 0.714 ms, Inlining 0.000 ms, Optimization 0.780 ms, Emission 16.721 ms, Total 18.215 ms
                 Buffers: shared hit=2351 read=21858
               ->  Parallel Seq Scan on public.prices  (cost=0.00..95722.40 rows=4166740 width=0) (actual time=0.127..610.748 rows=3333333 loops=3)
                     Output: price_id, product_id, price
                     Buffers: shared hit=5147 read=48908
                     Worker 0:  actual time=0.181..585.297 rows=2656795 loops=1
                       Buffers: shared hit=1338 read=13024
                     Worker 1:  actual time=0.127..565.420 rows=4478665 loops=1
                       Buffers: shared hit=2351 read=21858
 Planning Time: 0.160 ms
 JIT:
   Functions: 8
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 2.791 ms, Inlining 0.000 ms, Optimization 2.370 ms, Emission 62.897 ms, Total 68.058 ms
 Execution Time: 1137.973 ms
(36 rows)

commercedb=# SELECT * FROM Prices ORDER BY Price_id LIMIT 10;
 price_id | product_id | price  
----------+------------+--------
        1 |   20000001 | 618.01
        2 |   20000002 | 164.21
        3 |   20000003 | 222.54
        4 |   20000004 | 682.18
        5 |   20000005 | 766.80
        6 |   20000006 | 506.21
        7 |   20000007 |  19.03
        8 |   20000008 |  44.62
        9 |   20000009 | 893.28
       10 |   20000010 | 880.77
(10 rows)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT * FROM Prices ORDER BY Price_id LIMIT 10;
                                                                  QUERY PLAN                                                                   
-----------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.43..0.75 rows=10 width=14) (actual time=0.053..0.067 rows=10 loops=1)
   Output: price_id, product_id, price
   Buffers: shared hit=4
   ->  Index Scan using prices_pkey on public.prices  (cost=0.43..313745.06 rows=10000175 width=14) (actual time=0.051..0.059 rows=10 loops=1)
         Output: price_id, product_id, price
         Buffers: shared hit=4
 Planning Time: 0.186 ms
 Execution Time: 0.105 ms
(8 rows)

commercedb=# SELECT MIN(Price_id), MAX(Price_id) FROM Prices;
 min |   max    
-----+----------
   1 | 10000000
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT MIN(Price_id), MAX(Price_id) FROM Prices;
                                                                                 QUERY PLAN                                                                                 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Result  (cost=0.93..0.94 rows=1 width=8) (actual time=0.238..0.244 rows=1 loops=1)
   Output: $0, $1
   Buffers: shared hit=8
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.43..0.46 rows=1 width=4) (actual time=0.155..0.158 rows=1 loops=1)
           Output: prices.price_id
           Buffers: shared hit=4
           ->  Index Only Scan using prices_pkey on public.prices  (cost=0.43..284687.50 rows=10000175 width=4) (actual time=0.150..0.151 rows=1 loops=1)
                 Output: prices.price_id
                 Index Cond: (prices.price_id IS NOT NULL)
                 Heap Fetches: 0
                 Buffers: shared hit=4
   InitPlan 2 (returns $1)
     ->  Limit  (cost=0.43..0.46 rows=1 width=4) (actual time=0.064..0.065 rows=1 loops=1)
           Output: prices_1.price_id
           Buffers: shared hit=4
           ->  Index Only Scan Backward using prices_pkey on public.prices prices_1  (cost=0.43..284687.50 rows=10000175 width=4) (actual time=0.062..0.063 rows=1 loops=1)
                 Output: prices_1.price_id
                 Index Cond: (prices_1.price_id IS NOT NULL)
                 Heap Fetches: 0
                 Buffers: shared hit=4
 Planning Time: 0.676 ms
 Execution Time: 0.387 ms
(23 rows)


--- SQL Code for Orders Table Creation
commercedb=# DROP TABLE IF EXISTS Orders;
NOTICE:  table "orders" does not exist, skipping
DROP TABLE
commercedb=# DROP TABLE IF EXISTS Orders;
NOTICE:  table "orders" does not exist, skipping
DROP TABLE
commercedb=# CREATE TABLE Orders (
    Order_id SERIAL PRIMARY KEY,
    Order_date TIMESTAMP,
    Quantity INT NOT NULL,
    Customer_id INT NOT NULL,
    Product_id INT NOT NULL,
    FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id),
    FOREIGN KEY (Product_id) REFERENCES Products(Product_id)
);
CREATE TABLE
commercedb=# \dt
           List of relations
 Schema |   Name    | Type  |  Owner   
--------+-----------+-------+----------
 public | accounts  | table | postgres
 public | customers | table | postgres
 public | orders    | table | postgres
 public | prices    | table | postgres
 public | products  | table | postgres
 public | suppliers | table | postgres
(6 rows)

commercedb=# \d orders
                                            Table "public.orders"
   Column    |            Type             | Collation | Nullable |                 Default                  
-------------+-----------------------------+-----------+----------+------------------------------------------
 order_id    | integer                     |           | not null | nextval('orders_order_id_seq'::regclass)
 order_date  | timestamp without time zone |           |          | 
 quantity    | integer                     |           | not null | 
 customer_id | integer                     |           | not null | 
 product_id  | integer                     |           | not null | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (order_id)
Foreign-key constraints:
    "orders_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    "orders_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(product_id)

commercedb=# DO $$
DECLARE
    batch_size INT := 1000000;
    batches INT := 300;
BEGIN
   FOR i IN 1..batches Loop 
       INSERT INTO Orders (Order_date, Quantity, Customer_id, product_id)
       SELECT
           NOW() - (random() * interval '365 days') AS Order_date,                                  
           (random() * 100)::INT + 1 AS Quantity,                                                      
           (random() * (SELECT MAX(Customer_id) FROM Customers))::INT + 1 AS Customer_id,
           (random() * (SELECT MAX(Product_id) FROM Products))::INT + 1 AS Product_id
       FROM
          generate_series(1, 300000000);  
       COMMIT;
    END LOOP;
END $$;

ERROR:  insert or update on table "orders" violates foreign key constraint "orders_product_id_fkey"
DETAIL:  Key (product_id)=(15638875) is not present in table "products".
CONTEXT:  SQL statement "INSERT INTO Orders (Order_date, Quantity, Customer_id, product_id)
       SELECT
           NOW() - (random() * interval '365 days') AS Order_date, 
           (random() * 100)::INT + 1 AS Quantity,                  
           (random() * (SELECT MAX(Customer_id) FROM Customers))::INT + 1 AS Customer_id,
           (random() * (SELECT MAX(Product_id) FROM Products))::INT + 1 AS Product_id
       FROM
          generate_series(1, 300000000)"
PL/pgSQL function inline_code_block line 7 at SQL statement
commercedb=# 
commercedb=# DO $$
DECLARE
    batch_size INT := 1000000;
    batches INT := 300;
BEGIN
   FOR i IN 1..batches LOOP 
       INSERT INTO Orders (Order_date, Quantity, Customer_id, product_id)
       SELECT
           NOW() - (random() * interval '365 days') AS Order_date,                      
           (random() * 100)::INT + 1 AS Quantity,                                          
           (random() * (SELECT MAX(Customer_id) FROM Customers))::INT + 1 AS Customer_id,
           (SELECT Product_id FROM Products ORDER BY random() LIMIT 1) AS Product_id
       FROM
          generate_series(1, batch_size);  
       COMMIT;
    END LOOP;
END $$;


ERROR:  insert or update on table "orders" violates foreign key constraint "orders_customer_id_fkey"
DETAIL:  Key (customer_id)=(30000001) is not present in table "customers".
CONTEXT:  SQL statement "INSERT INTO Orders (Order_date, Quantity, Customer_id, product_id)
       SELECT
           NOW() - (random() * interval '365 days') AS Order_date,
           (random() * 100)::INT + 1 AS Quantity,                  
           (random() * (SELECT MAX(Customer_id) FROM Customers))::INT + 1 AS Customer_id,
           (SELECT Product_id FROM Products ORDER BY random() LIMIT 1) AS Product_id
       FROM
          generate_series(1, batch_size)"
PL/pgSQL function inline_code_block line 7 at SQL statement
commercedb=# 
commercedb=# 
commercedb=# DO $$
DECLARE
    batch_size INT := 1000000;
    batches INT := 300;
BEGIN
   FOR i IN 1..batches LOOP 
       BEGIN
           INSERT INTO Orders (Order_date, Quantity, Customer_id, product_id)
           SELECT
               NOW() - (random() * interval '365 days') AS Order_date,                                  
               (random() * 100)::INT + 1 AS Quantity,                                             
               (SELECT Customer_id FROM Customers ORDER BY random() LIMIT 1) AS Customer_id,
               (SELECT Product_id FROM Products ORDER BY random() LIMIT 1) AS Product_id
           FROM
              generate_series(1, batch_size);  
           COMMIT;
        END;   
    END LOOP;
END $$;
DO
commercedb=# SELECT COUNT(*) FROM Orders;
   count   
-----------
 390000000
(1 row)

commercedb=# SELECT * FROM Orders ORDER BY Order_id LIMIT 10;
 order_id  |         order_date         | quantity | customer_id | product_id 
-----------+----------------------------+----------+-------------+------------
 300000001 | 2024-06-17 06:57:28.9801   |       95 |      342077 |   20061275
 300000002 | 2023-10-15 03:15:43.427656 |       61 |    17715687 |   20061275
 300000003 | 2023-12-21 09:42:45.170483 |       13 |    29670785 |   20061275
 300000004 | 2024-02-19 18:51:55.669054 |       75 |    13757292 |   20061275
 300000005 | 2024-07-04 04:56:31.251334 |       27 |    25267022 |   20061275
 300000006 | 2023-11-05 23:04:04.451457 |        1 |    11792174 |   20061275
 300000007 | 2023-12-06 08:53:12.345439 |       10 |     8181127 |   20061275
 300000008 | 2023-10-23 22:18:45.486806 |       89 |    19349846 |   20061275
 300000009 | 2024-05-07 16:31:16.402218 |       27 |     5153765 |   20061275
 300000010 | 2023-12-25 18:54:21.568847 |        2 |    18655160 |   20061275
(10 rows)

commercedb=# SELECT MIN(order_id), MAX(order_id) FROM Orders;
    min    |    max    
-----------+-----------
 300000001 | 691000000
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT * FROM Orders ORDER BY Order_id LIMIT 10;
                                                                    QUERY PLAN                                                                    
--------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.57..0.91 rows=10 width=24) (actual time=0.055..0.067 rows=10 loops=1)
   Output: order_id, order_date, quantity, customer_id, product_id
   Buffers: shared hit=5
   ->  Index Scan using orders_pkey on public.orders  (cost=0.57..13013820.37 rows=390035520 width=24) (actual time=0.053..0.061 rows=10 loops=1)
         Output: order_id, order_date, quantity, customer_id, product_id
         Buffers: shared hit=5
 Planning Time: 0.196 ms
 Execution Time: 0.120 ms
(8 rows)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT COUNT(*) FROM Orders;
                                                                         QUERY PLAN                                                                         
------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=4907435.21..4907435.22 rows=1 width=8) (actual time=62488.203..62498.642 rows=1 loops=1)
   Output: count(*)
   Buffers: shared hit=7486 read=2867514
   ->  Gather  (cost=4907435.00..4907435.21 rows=2 width=8) (actual time=62486.891..62498.586 rows=3 loops=1)
         Output: (PARTIAL count(*))
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=7486 read=2867514
         ->  Partial Aggregate  (cost=4906435.00..4906435.01 rows=1 width=8) (actual time=62428.685..62428.686 rows=1 loops=3)
               Output: PARTIAL count(*)
               Buffers: shared hit=7486 read=2867514
               Worker 0:  actual time=62399.938..62399.939 rows=1 loops=1
                 JIT:
                   Functions: 2
                   Options: Inlining true, Optimization true, Expressions true, Deforming true
                   Timing: Generation 0.253 ms, Inlining 113.019 ms, Optimization 4.111 ms, Emission 8.147 ms, Total 125.530 ms
                 Buffers: shared hit=2232 read=950355
               Worker 1:  actual time=62399.935..62399.937 rows=1 loops=1
                 JIT:
                   Functions: 2
                   Options: Inlining true, Optimization true, Expressions true, Deforming true
                   Timing: Generation 0.259 ms, Inlining 114.393 ms, Optimization 3.918 ms, Emission 7.591 ms, Total 126.160 ms
                 Buffers: shared hit=2394 read=959762
               ->  Parallel Seq Scan on public.orders  (cost=0.00..4500148.00 rows=162514800 width=0) (actual time=0.582..52253.948 rows=130000000 loops=3)
                     Output: order_id, order_date, quantity, customer_id, product_id
                     Buffers: shared hit=7486 read=2867514
                     Worker 0:  actual time=0.870..52239.255 rows=129273304 loops=1
                       Buffers: shared hit=2232 read=950355
                     Worker 1:  actual time=0.863..52242.909 rows=130410354 loops=1
                       Buffers: shared hit=2394 read=959762
 Planning Time: 0.130 ms
 JIT:
   Functions: 8
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 1.364 ms, Inlining 257.080 ms, Optimization 44.332 ms, Emission 31.707 ms, Total 334.483 ms
 Execution Time: 62499.626 ms
(36 rows)


---Sql code for Orders table Now updated
commercedb=# DROP TABLE IF EXISTS Orders;
DROP TABLE
commercedb=# \dt
           List of relations
 Schema |   Name    | Type  |  Owner   
--------+-----------+-------+----------
 public | accounts  | table | postgres
 public | customers | table | postgres
 public | prices    | table | postgres
 public | products  | table | postgres
 public | suppliers | table | postgres
(5 rows)

commercedb=# CREATE TABLE Orders (
    Order_id SERIAL PRIMARY KEY,
    Order_date TIMESTAMP,
    Quantity INT NOT NULL,
    Customer_id INT NOT NULL,
    Product_id INT NOT NULL,
    FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id),
    FOREIGN KEY (Product_id) REFERENCES Products(Product_id)
);
CREATE TABLE
commercedb=# DO $$
DECLARE
    batch_size INT := 1000000;
    batches INT := 300;
BEGIN
   FOR i IN 1..batches LOOP 
       INSERT INTO Orders (Order_date, Quantity, Customer_id, product_id)
       SELECT
           NOW() - (random() * interval '365 days') AS Order_date,                        
           (random() * 100)::INT + 1 AS Quantity,                                               
           (SELECT Customer_id FROM Customers ORDER BY random() LIMIT 1) AS Customer_id,
           (SELECT Product_id FROM Products ORDER BY random() LIMIT 1) AS Product_id
       FROM
          generate_series(1, batch_size);    
    END LOOP;
END $$;
DO
commercedb=# SELECT COUNT(*) FROM Orders;
   count   
-----------
 300000000
(1 row)

commercedb=# SELECT * FROM orders ORDER BY order_id LIMIT 10;
 order_id |         order_date         | quantity | customer_id | product_id 
----------+----------------------------+----------+-------------+------------
        1 | 2024-06-01 07:06:04.704536 |       77 |    22270926 |   26852766
        2 | 2024-05-20 05:16:07.742605 |       92 |    22270926 |   26852766
        3 | 2023-10-07 18:20:47.263589 |       36 |    22270926 |   26852766
        4 | 2024-03-02 20:00:42.749155 |       80 |    22270926 |   26852766
        5 | 2023-11-08 14:45:49.052055 |       44 |    22270926 |   26852766
        6 | 2024-05-30 13:57:45.16799  |       78 |    22270926 |   26852766
        7 | 2023-09-05 02:29:34.335956 |       79 |    22270926 |   26852766
        8 | 2024-03-01 17:39:21.94576  |       90 |    22270926 |   26852766
        9 | 2024-03-19 02:41:24.390653 |       19 |    22270926 |   26852766
       10 | 2024-02-25 04:40:29.371175 |        9 |    22270926 |   26852766
(10 rows)

commercedb=# SELECT MIN(order_id), MAX(order_id) FROM Orders;
 min |    max    
-----+-----------
   1 | 300000000
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT MIN(order_id), MAX(order_id) FROM Orders;
                                                                                  QUERY PLAN                                                                                  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Result  (cost=1.20..1.21 rows=1 width=8) (actual time=0.150..0.155 rows=1 loops=1)
   Output: $0, $1
   Buffers: shared hit=10
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.57..0.60 rows=1 width=4) (actual time=0.102..0.104 rows=1 loops=1)
           Output: orders.order_id
           Buffers: shared hit=5
           ->  Index Only Scan using orders_pkey on public.orders  (cost=0.57..8540246.25 rows=300000096 width=4) (actual time=0.100..0.100 rows=1 loops=1)
                 Output: orders.order_id
                 Index Cond: (orders.order_id IS NOT NULL)
                 Heap Fetches: 0
                 Buffers: shared hit=5
   InitPlan 2 (returns $1)
     ->  Limit  (cost=0.57..0.60 rows=1 width=4) (actual time=0.037..0.038 rows=1 loops=1)
           Output: orders_1.order_id
           Buffers: shared hit=5
           ->  Index Only Scan Backward using orders_pkey on public.orders orders_1  (cost=0.57..8540246.25 rows=300000096 width=4) (actual time=0.035..0.036 rows=1 loops=1)
                 Output: orders_1.order_id
                 Index Cond: (orders_1.order_id IS NOT NULL)
                 Heap Fetches: 0
                 Buffers: shared hit=5
 Planning Time: 0.495 ms
 Execution Time: 0.235 ms
(23 rows)



