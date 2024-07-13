

commercedb=# SELECT * FROM Orders ORDER BY Order_id LIMIT 10;
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

--Before Optimization

commercedb=# \d Orders
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

-- Try 1

commercedb=# SELECT Order_id, Order_date, Quantity, Customer_id, Product_id FROM Orders WHERE Customer_id = 22270926 AND Order_date = '2024-03-02 20:00:42.749155';
 order_id |         order_date         | quantity | customer_id | product_id 
----------+----------------------------+----------+-------------+------------
        4 | 2024-03-02 20:00:42.749155 |       80 |    22270926 |   26852766
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT Order_id, Order_date, Quantity, Customer_id, Product_id FROM Orders WHERE Customer_id = 22270926 AND Order_date = '2024-03-02 20:00:42.749155';
                                                              QUERY PLAN                                                               
---------------------------------------------------------------------------------------------------------------------------------------
 Gather  (cost=1000.00..4081883.70 rows=1 width=24) (actual time=50.624..32655.524 rows=1 loops=1)
   Output: order_id, order_date, quantity, customer_id, product_id
   Workers Planned: 2
   Workers Launched: 2
   Buffers: shared hit=385 read=2205498
   ->  Parallel Seq Scan on public.orders  (cost=0.00..4080883.60 rows=1 width=24) (actual time=21742.519..32605.785 rows=0 loops=3)
         Output: order_id, order_date, quantity, customer_id, product_id
         Filter: ((orders.customer_id = 22270926) AND (orders.order_date = '2024-03-02 20:00:42.749155'::timestamp without time zone))
         Rows Removed by Filter: 100000000
         Buffers: shared hit=385 read=2205498
         Worker 0:  actual time=32592.329..32592.330 rows=0 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 0.331 ms, Inlining 78.493 ms, Optimization 8.310 ms, Emission 7.389 ms, Total 94.523 ms
           Buffers: shared hit=110 read=751348
         Worker 1:  actual time=32585.784..32585.786 rows=0 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 0.441 ms, Inlining 108.882 ms, Optimization 8.621 ms, Emission 7.741 ms, Total 125.685 ms
           Buffers: shared hit=105 read=721892
 Planning Time: 0.329 ms
 JIT:
   Functions: 6
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 2.593 ms, Inlining 210.891 ms, Optimization 33.881 ms, Emission 24.070 ms, Total 271.434 ms
 Execution Time: 32657.586 ms
(28 rows)




--Try 2

commercedb=# SELECT Order_id, Order_date, Quantity, Customer_id, Product_id FROM Orders WHERE Customer_id = 22270926 AND Order_date = '2024-03-02 20:00:42.749155';
 order_id |         order_date         | quantity | customer_id | product_id 
----------+----------------------------+----------+-------------+------------
        4 | 2024-03-02 20:00:42.749155 |       80 |    22270926 |   26852766
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT Order_id, Order_date, Quantity, Customer_id, Product_id FROM Orders WHERE Customer_id = 22270926 AND Order_date = '2024-03-02 20:00:42.749155';
                                                              QUERY PLAN                                                               
---------------------------------------------------------------------------------------------------------------------------------------
 Gather  (cost=1000.00..4081883.70 rows=1 width=24) (actual time=52.804..35509.418 rows=1 loops=1)
   Output: order_id, order_date, quantity, customer_id, product_id
   Workers Planned: 2
   Workers Launched: 2
   Buffers: shared hit=577 read=2205306
   ->  Parallel Seq Scan on public.orders  (cost=0.00..4080883.60 rows=1 width=24) (actual time=23636.798..35448.720 rows=0 loops=3)
         Output: order_id, order_date, quantity, customer_id, product_id
         Filter: ((orders.customer_id = 22270926) AND (orders.order_date = '2024-03-02 20:00:42.749155'::timestamp without time zone))
         Rows Removed by Filter: 100000000
         Buffers: shared hit=577 read=2205306
         Worker 0:  actual time=35427.853..35427.856 rows=0 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 0.353 ms, Inlining 98.664 ms, Optimization 8.422 ms, Emission 7.900 ms, Total 115.339 ms
           Buffers: shared hit=204 read=708352
         Worker 1:  actual time=35430.326..35430.329 rows=0 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 0.306 ms, Inlining 88.708 ms, Optimization 7.268 ms, Emission 7.046 ms, Total 103.329 ms
           Buffers: shared hit=162 read=750868
 Planning Time: 0.171 ms
 JIT:
   Functions: 6
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 1.225 ms, Inlining 208.636 ms, Optimization 38.343 ms, Emission 23.209 ms, Total 271.413 ms
 Execution Time: 35510.172 ms
(28 rows)




--Try 3

commercedb=# SELECT Order_id, Order_date, Quantity, Customer_id, Product_id FROM Orders WHERE Customer_id = 22270926 AND Order_date = '2024-03-02 20:00:42.749155';
 order_id |         order_date         | quantity | customer_id | product_id 
----------+----------------------------+----------+-------------+------------
        4 | 2024-03-02 20:00:42.749155 |       80 |    22270926 |   26852766
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT Order_id, Order_date, Quantity, Customer_id, Product_id FROM Orders WHERE Customer_id = 22270926 AND Order_date = '2024-03-02 20:00:42.749155';
                                                              QUERY PLAN                                                               
---------------------------------------------------------------------------------------------------------------------------------------
 Gather  (cost=1000.00..4081883.70 rows=1 width=24) (actual time=56.514..38317.278 rows=1 loops=1)
   Output: order_id, order_date, quantity, customer_id, product_id
   Workers Planned: 2
   Workers Launched: 2
   Buffers: shared hit=769 read=2205114
   ->  Parallel Seq Scan on public.orders  (cost=0.00..4080883.60 rows=1 width=24) (actual time=25520.247..38270.961 rows=0 loops=3)
         Output: order_id, order_date, quantity, customer_id, product_id
         Filter: ((orders.customer_id = 22270926) AND (orders.order_date = '2024-03-02 20:00:42.749155'::timestamp without time zone))
         Rows Removed by Filter: 100000000
         Buffers: shared hit=769 read=2205114
         Worker 0:  actual time=38253.444..38253.445 rows=0 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 0.301 ms, Inlining 73.719 ms, Optimization 6.987 ms, Emission 6.865 ms, Total 87.872 ms
           Buffers: shared hit=193 read=716444
         Worker 1:  actual time=38251.662..38251.663 rows=0 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 0.429 ms, Inlining 112.461 ms, Optimization 7.160 ms, Emission 9.228 ms, Total 129.278 ms
           Buffers: shared hit=196 read=758408
 Planning Time: 0.266 ms
 JIT:
   Functions: 6
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 1.656 ms, Inlining 216.389 ms, Optimization 30.362 ms, Emission 25.273 ms, Total 273.680 ms
 Execution Time: 38318.312 ms
(28 rows)


--Optimizing the column