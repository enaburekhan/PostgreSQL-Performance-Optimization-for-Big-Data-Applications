commercedb=# SELECT * FROM Orders ORDER BY Order_id LIMIT 10;
 order_id |         order_date         | quantity | customer_id 
----------+----------------------------+----------+-------------
        1 | 2023-11-21 16:31:21.334746 |       55 |    13252175
        2 | 2023-12-11 23:21:46.461502 |       18 |    13252175
        3 | 2024-07-06 02:37:31.547549 |       73 |    13252175
        4 | 2024-07-08 19:20:39.186411 |       24 |    13252175
        5 | 2024-03-05 08:26:21.568922 |       90 |    13252175
        6 | 2024-05-11 01:52:49.200203 |        6 |    13252175
        7 | 2024-04-11 05:08:13.33689  |       72 |    13252175
        8 | 2023-09-11 09:16:19.014007 |       95 |    13252175
        9 | 2023-11-04 07:14:15.090708 |       31 |    13252175
       10 | 2024-02-10 13:21:07.063455 |        2 |    13252175
(10 rows)

Before Optimization

Try1

commercedb=# SELECT Order_id, Order_date, Quantity, Customer_id FROM Orders WHERE Customer_id = 13252175 AND Order_date = '2024-04-11 05:08:13.33689';
 order_id |        order_date         | quantity | customer_id 
----------+---------------------------+----------+-------------
        7 | 2024-04-11 05:08:13.33689 |       72 |    13252175
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT Order_id, Order_date, Quantity, Customer_id FROM Orders WHERE Customer_id = 13252175 AND Order_date = '2024-04-11 05:08:13.33689';
                                                              QUERY PLAN                                                               
---------------------------------------------------------------------------------------------------------------------------------------
 Gather  (cost=1000.00..3786830.10 rows=1 width=20) (actual time=421610.628..421749.508 rows=1 loops=1)
   Output: order_id, order_date, quantity, customer_id
   Workers Planned: 2
   Workers Launched: 2
   Buffers: shared hit=280179 read=1630650
   ->  Parallel Seq Scan on public.orders  (cost=0.00..3785830.00 rows=1 width=20) (actual time=391810.848..421533.285 rows=0 loops=3)
         Output: order_id, order_date, quantity, customer_id
         Filter: ((orders.customer_id = 13252175) AND (orders.order_date = '2024-04-11 05:08:13.33689'::timestamp without time zone))
         Rows Removed by Filter: 100000000
         Buffers: shared hit=280179 read=1630650
         Worker 0:  actual time=332327.946..421495.248 rows=1 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 0.472 ms, Inlining 84.075 ms, Optimization 6.730 ms, Emission 7.562 ms, Total 98.839 ms
           Buffers: shared hit=97150 read=542911
         Worker 1:  actual time=421494.972..421494.976 rows=0 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 0.474 ms, Inlining 83.325 ms, Optimization 7.137 ms, Emission 8.274 ms, Total 99.210 ms
           Buffers: shared hit=98890 read=543747
 Planning Time: 0.492 ms
 JIT:
   Functions: 6
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 2.140 ms, Inlining 202.900 ms, Optimization 63.646 ms, Emission 29.376 ms, Total 298.062 ms
 Execution Time: 421751.036 ms
(28 rows)


Try2

commercedb=# SELECT Order_id, Order_date, Quantity, Customer_id FROM Orders WHERE Customer_id = 13252175 AND Order_date = '2024-04-11 05:08:13.33689';
 order_id |        order_date         | quantity | customer_id 
----------+---------------------------+----------+-------------
        7 | 2024-04-11 05:08:13.33689 |       72 |    13252175
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT Order_id, Order_date, Quantity, Customer_id FROM Orders WHERE Customer_id = 13252175 AND Order_date = '2024-04-11 05:08:13.33689';
                                                              QUERY PLAN                                                               
---------------------------------------------------------------------------------------------------------------------------------------
 Gather  (cost=1000.00..3786830.10 rows=1 width=20) (actual time=368139.303..368263.823 rows=1 loops=1)
   Output: order_id, order_date, quantity, customer_id
   Workers Planned: 2
   Workers Launched: 2
   Buffers: shared hit=280371 read=1630458
   ->  Parallel Seq Scan on public.orders  (cost=0.00..3785830.00 rows=1 width=20) (actual time=351320.154..368050.926 rows=0 loops=3)
         Output: order_id, order_date, quantity, customer_id
         Filter: ((orders.customer_id = 13252175) AND (orders.order_date = '2024-04-11 05:08:13.33689'::timestamp without time zone))
         Rows Removed by Filter: 100000000
         Buffers: shared hit=280371 read=1630458
         Worker 0:  actual time=317827.984..368020.291 rows=1 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 3.804 ms, Inlining 148.649 ms, Optimization 11.346 ms, Emission 10.178 ms, Total 173.978 ms
           Buffers: shared hit=90003 read=533834
         Worker 1:  actual time=367994.230..367994.234 rows=0 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 0.510 ms, Inlining 165.731 ms, Optimization 9.651 ms, Emission 9.743 ms, Total 185.636 ms
           Buffers: shared hit=106808 read=562543
 Planning Time: 0.286 ms
 JIT:
   Functions: 6
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 5.077 ms, Inlining 332.539 ms, Optimization 101.531 ms, Emission 50.537 ms, Total 489.685 ms
 Execution Time: 368264.704 ms
(28 rows)


Try3

commercedb=# SELECT Order_id, Order_date, Quantity, Customer_id FROM Orders WHERE Customer_id = 13252175 AND Order_date = '2024-04-11 05:08:13.33689';
 order_id |        order_date         | quantity | customer_id 
----------+---------------------------+----------+-------------
        7 | 2024-04-11 05:08:13.33689 |       72 |    13252175
(1 row)

commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) SELECT Order_id, Order_date, Quantity, Customer_id FROM Orders WHERE Customer_id = 13252175 AND Order_date = '2024-04-11 05:08:13.33689';
                                                              QUERY PLAN                                                               
---------------------------------------------------------------------------------------------------------------------------------------
 Gather  (cost=1000.00..3786830.10 rows=1 width=20) (actual time=325214.907..409525.993 rows=1 loops=1)
   Output: order_id, order_date, quantity, customer_id
   Workers Planned: 2
   Workers Launched: 2
   Buffers: shared hit=280563 read=1630266
   ->  Parallel Seq Scan on public.orders  (cost=0.00..3785830.00 rows=1 width=20) (actual time=381284.409..409363.712 rows=0 loops=3)
         Output: order_id, order_date, quantity, customer_id
         Filter: ((orders.customer_id = 13252175) AND (orders.order_date = '2024-04-11 05:08:13.33689'::timestamp without time zone))
         Rows Removed by Filter: 100000000
         Buffers: shared hit=280563 read=1630266
         Worker 0:  actual time=409321.988..409322.013 rows=0 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 0.340 ms, Inlining 69.625 ms, Optimization 6.713 ms, Emission 6.543 ms, Total 83.221 ms
           Buffers: shared hit=114177 read=550201
         Worker 1:  actual time=409317.125..409317.127 rows=0 loops=1
           JIT:
             Functions: 2
             Options: Inlining true, Optimization true, Expressions true, Deforming true
             Timing: Generation 0.473 ms, Inlining 115.401 ms, Optimization 9.797 ms, Emission 9.501 ms, Total 135.171 ms
           Buffers: shared hit=79880 read=533264
 Planning Time: 0.293 ms
 JIT:
   Functions: 6
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 1.634 ms, Inlining 198.750 ms, Optimization 39.944 ms, Emission 23.158 ms, Total 263.486 ms
 Execution Time: 409526.911 ms
(28 rows)
