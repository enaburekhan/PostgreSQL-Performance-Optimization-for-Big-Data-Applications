
commercedb=# SELECT c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, p.product_name, pr.price, s.supplier_name, a.balance
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN accounts a ON c.customer_id = a.customer_id
JOIN products p ON p.supplier_id = (SELECT supplier_id FROM suppliers WHERE supplier_name = '0202521e5b58ac90e003a8d0025621c4' LIMIT 1)
JOIN prices pr ON pr.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE o.order_date = '2023-11-21 16:31:21.334746'
  AND pr.price > (SELECT AVG(price) FROM prices)
ORDER BY o.order_date DESC LIMIT 10;


--Before optimization

         customer_name            |           contact_info           | order_id |         order_date         | quantity |           product_name           | price  |          supplier_name           | balance 
----------------------------------+----------------------------------+----------+----------------------------+----------+----------------------------------+--------+----------------------------------+---------
 a2b3435aaa80aa2d902f1d2b369c2278 | db77d5d2bbd71d08e40400f4063f2498 |        1 | 2023-11-21 16:31:21.334746 |       55 | 5b8d37b54f3899e60f7ae282a2adb417 | 643.16 | 0202521e5b58ac90e003a8d0025621c4 | 2130.84
 a2b3435aaa80aa2d902f1d2b369c2278 | db77d5d2bbd71d08e40400f4063f2498 |        1 | 2023-11-21 16:31:21.334746 |       55 | 3d7083df08ac89415ea1402b65976604 | 868.23 | 0202521e5b58ac90e003a8d0025621c4 | 2130.84
 a2b3435aaa80aa2d902f1d2b369c2278 | db77d5d2bbd71d08e40400f4063f2498 |        1 | 2023-11-21 16:31:21.334746 |       55 | 326aafc6b1c7015ae6d976ec91719300 | 851.37 | 0202521e5b58ac90e003a8d0025621c4 | 2130.84
 a2b3435aaa80aa2d902f1d2b369c2278 | db77d5d2bbd71d08e40400f4063f2498 |        1 | 2023-11-21 16:31:21.334746 |       55 | 3ed7b9547ff22a0f7cdcf5f68d12dc58 | 902.78 | 0202521e5b58ac90e003a8d0025621c4 | 2130.84
 a2b3435aaa80aa2d902f1d2b369c2278 | db77d5d2bbd71d08e40400f4063f2498 |        1 | 2023-11-21 16:31:21.334746 |       55 | 91b9190fa259fcca15f679f827544ccc | 777.82 | 0202521e5b58ac90e003a8d0025621c4 | 2130.84
 a2b3435aaa80aa2d902f1d2b369c2278 | db77d5d2bbd71d08e40400f4063f2498 |        1 | 2023-11-21 16:31:21.334746 |       55 | ebf25788435f312ca1304e289b943aed | 916.16 | 0202521e5b58ac90e003a8d0025621c4 | 2130.84
 a2b3435aaa80aa2d902f1d2b369c2278 | db77d5d2bbd71d08e40400f4063f2498 |        1 | 2023-11-21 16:31:21.334746 |       55 | 03f8977e181da268e7d12b0be4df1856 | 790.07 | 0202521e5b58ac90e003a8d0025621c4 | 2130.84
 a2b3435aaa80aa2d902f1d2b369c2278 | db77d5d2bbd71d08e40400f4063f2498 |        1 | 2023-11-21 16:31:21.334746 |       55 | 92b54cd83b04c83a1748377b1dbeaf85 | 608.31 | 0202521e5b58ac90e003a8d0025621c4 | 2130.84
 a2b3435aaa80aa2d902f1d2b369c2278 | db77d5d2bbd71d08e40400f4063f2498 |        1 | 2023-11-21 16:31:21.334746 |       55 | e7a87f5619045f22afa9198411915631 | 781.14 | 0202521e5b58ac90e003a8d0025621c4 | 2130.84
 a2b3435aaa80aa2d902f1d2b369c2278 | db77d5d2bbd71d08e40400f4063f2498 |        1 | 2023-11-21 16:31:21.334746 |       55 | e80a6769dcd1974a4a0be18738e5e7f7 | 933.71 | 0202521e5b58ac90e003a8d0025621c4 | 2130.84
(10 rows)



--Try1
commercedb=# EXPLAIN (ANALYZE, BUFFERS) SELECT c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, p.product_name, pr.price, s.supplier_name, a.balance
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN accounts a ON c.customer_id = a.customer_id
JOIN products p ON p.supplier_id = (SELECT supplier_id FROM suppliers WHERE supplier_name = '0202521e5b58ac90e003a8d0025621c4' LIMIT 1)
JOIN prices pr ON pr.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE o.order_date = '2023-11-21 16:31:21.334746'
  AND pr.price > (SELECT AVG(price) FROM prices)
ORDER BY o.order_date DESC LIMIT 10;
                                                                          QUERY PLAN                                                                          
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=257167.54..1311031.52 rows=10 width=160) (actual time=15686.259..39531.970 rows=10 loops=1)
   Buffers: shared hit=489442 read=1622713
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.024..0.026 rows=1 loops=1)
           Buffers: shared hit=1
           ->  Seq Scan on suppliers  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.020..0.020 rows=1 loops=1)
                 Filter: ((supplier_name)::text = '0202521e5b58ac90e003a8d0025621c4'::text)
                 Buffers: shared hit=1
   InitPlan 2 (returns $2)
     ->  Finalize Aggregate  (cost=107139.47..107139.48 rows=1 width=32) (actual time=1637.702..1637.798 rows=1 loops=1)
           Buffers: shared hit=54055
           ->  Gather  (cost=107139.25..107139.46 rows=2 width=32) (actual time=1637.541..1637.762 rows=3 loops=1)
                 Workers Planned: 2
                 Workers Launched: 2
                 Buffers: shared hit=54055
                 ->  Partial Aggregate  (cost=106139.25..106139.26 rows=1 width=32) (actual time=1592.105..1592.106 rows=1 loops=3)
                       Buffers: shared hit=54055
                       ->  Parallel Seq Scan on prices  (cost=0.00..95722.40 rows=4166740 width=6) (actual time=0.019..566.449 rows=3333333 loops=3)
                             Buffers: shared hit=54055
   ->  Nested Loop  (cost=147543.06..3730680.61 rows=34 width=160) (actual time=15280.792..39126.397 rows=10 loops=1)
         Buffers: shared hit=489442 read=1622713
         ->  Nested Loop  (cost=1001.17..3474349.84 rows=1 width=125) (actual time=12941.566..36286.347 rows=1 loops=1)
               Buffers: shared hit=287758 read=1622713
               ->  Nested Loop  (cost=1000.88..3474341.52 rows=1 width=88) (actual time=12941.523..36286.302 rows=1 loops=1)
                     Buffers: shared hit=287754 read=1622713
                     ->  Nested Loop  (cost=1000.44..3474337.56 rows=1 width=90) (actual time=12941.495..36286.273 rows=1 loops=1)
                           Buffers: shared hit=287750 read=1622713
                           ->  Gather  (cost=1000.00..3474329.10 rows=1 width=20) (actual time=12941.419..36286.194 rows=1 loops=1)
                                 Workers Planned: 2
                                 Workers Launched: 2
                                 Buffers: shared hit=287746 read=1622713
                                 ->  Parallel Seq Scan on orders o  (cost=0.00..3473329.00 rows=1 width=20) (actual time=30303.564..30303.568 rows=0 loops=3)
                                       Filter: (order_date = '2023-11-21 16:31:21.334746'::timestamp without time zone)
                                       Rows Removed by Filter: 99980584
                                       Buffers: shared hit=287746 read=1622713
                           ->  Index Scan using customers_pkey on customers c  (cost=0.44..8.46 rows=1 width=70) (actual time=0.040..0.041 rows=1 loops=1)
                                 Index Cond: (customer_id = o.customer_id)
                                 Buffers: shared hit=4
                     ->  Index Scan using accounts_customer_id_key on accounts a  (cost=0.44..3.97 rows=1 width=10) (actual time=0.015..0.015 rows=1 loops=1)
                           Index Cond: (customer_id = c.customer_id)
                           Buffers: shared hit=4
               ->  Index Scan using suppliers_pkey on suppliers s  (cost=0.29..8.31 rows=1 width=37) (actual time=0.007..0.007 rows=1 loops=1)
                     Index Cond: (supplier_id = $0)
                     Buffers: shared hit=3
         ->  Gather  (cost=146541.89..256330.43 rows=34 width=43) (actual time=2339.220..2840.030 rows=10 loops=1)
               Workers Planned: 2
               Params Evaluated: $0, $2
               Workers Launched: 2
               Buffers: shared hit=201684
               ->  Parallel Hash Join  (cost=145541.89..255327.03 rows=14 width=43) (actual time=712.106..1854.844 rows=17 loops=3)
                     Hash Cond: (pr.product_id = p.product_id)
                     Buffers: shared hit=147629
                     ->  Parallel Seq Scan on prices pr  (cost=0.00..106139.24 rows=1388913 width=10) (actual time=0.039..953.806 rows=1666220 loops=3)
                           Filter: (price > $2)
                           Rows Removed by Filter: 1667061
                           Buffers: shared hit=54055
                     ->  Parallel Hash  (cost=145541.36..145541.36 rows=42 width=41) (actual time=657.778..657.779 rows=34 loops=3)
                           Buckets: 1024  Batches: 1  Memory Usage: 104kB
                           Buffers: shared hit=93458
                           ->  Parallel Seq Scan on products p  (cost=0.00..145541.36 rows=42 width=41) (actual time=286.695..657.589 rows=34 loops=3)
                                 Filter: (supplier_id = $0)
                                 Rows Removed by Filter: 3333300
                                 Buffers: shared hit=93458
 Planning:
   Buffers: shared hit=463
 Planning Time: 17.695 ms
 JIT:
   Functions: 114
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 11.644 ms, Inlining 1021.625 ms, Optimization 586.607 ms, Emission 465.183 ms, Total 2085.059 ms
 Execution Time: 39624.928 ms
(71 rows)


-- Try2
commercedb=# EXPLAIN (ANALYZE, BUFFERS) SELECT c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, p.product_name, pr.price, s.supplier_name, a.balance
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN accounts a ON c.customer_id = a.customer_id
JOIN products p ON p.supplier_id = (SELECT supplier_id FROM suppliers WHERE supplier_name = '0202521e5b58ac90e003a8d0025621c4' LIMIT 1)
JOIN prices pr ON pr.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE o.order_date = '2023-11-21 16:31:21.334746'
  AND pr.price > (SELECT AVG(price) FROM prices)
ORDER BY o.order_date DESC LIMIT 10;
                                                                        QUERY PLAN                                                                          
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=257167.54..1311031.52 rows=10 width=160) (actual time=18375.949..41675.649 rows=10 loops=1)
   Buffers: shared hit=489529 read=1622617
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.018..0.019 rows=1 loops=1)
           Buffers: shared hit=1
           ->  Seq Scan on suppliers  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.014..0.015 rows=1 loops=1)
                 Filter: ((supplier_name)::text = '0202521e5b58ac90e003a8d0025621c4'::text)
                 Buffers: shared hit=1
   InitPlan 2 (returns $2)
     ->  Finalize Aggregate  (cost=107139.47..107139.48 rows=1 width=32) (actual time=1650.842..1650.936 rows=1 loops=1)
           Buffers: shared hit=54055
           ->  Gather  (cost=107139.25..107139.46 rows=2 width=32) (actual time=1650.329..1650.836 rows=3 loops=1)
                 Workers Planned: 2
                 Workers Launched: 2
                 Buffers: shared hit=54055
                 ->  Partial Aggregate  (cost=106139.25..106139.26 rows=1 width=32) (actual time=1592.817..1592.818 rows=1 loops=3)
                       Buffers: shared hit=54055
                       ->  Parallel Seq Scan on prices  (cost=0.00..95722.40 rows=4166740 width=6) (actual time=0.016..575.387 rows=3333333 loops=3)
                             Buffers: shared hit=54055
   ->  Nested Loop  (cost=147543.06..3730680.61 rows=34 width=160) (actual time=17966.469..41266.067 rows=10 loops=1)
         Buffers: shared hit=489529 read=1622617
         ->  Nested Loop  (cost=1001.17..3474349.84 rows=1 width=125) (actual time=15195.147..36827.142 rows=1 loops=1)
               Buffers: shared hit=287854 read=1622617
               ->  Nested Loop  (cost=1000.88..3474341.52 rows=1 width=88) (actual time=15195.116..36827.109 rows=1 loops=1)
                     Buffers: shared hit=287850 read=1622617
                     ->  Nested Loop  (cost=1000.44..3474337.56 rows=1 width=90) (actual time=15195.096..36827.087 rows=1 loops=1)
                           Buffers: shared hit=287846 read=1622617
                           ->  Gather  (cost=1000.00..3474329.10 rows=1 width=20) (actual time=15195.034..36827.022 rows=1 loops=1)
                                 Workers Planned: 2
                                 Workers Launched: 2
                                 Buffers: shared hit=287842 read=1622617
                                 ->  Parallel Seq Scan on orders o  (cost=0.00..3473329.00 rows=1 width=20) (actual time=32488.224..32488.226 rows=0 loops=3)
                                       Filter: (order_date = '2023-11-21 16:31:21.334746'::timestamp without time zone)
                                       Rows Removed by Filter: 99980584
                                       Buffers: shared hit=287842 read=1622617
                           ->  Index Scan using customers_pkey on customers c  (cost=0.44..8.46 rows=1 width=70) (actual time=0.032..0.033 rows=1 loops=1)
                                 Index Cond: (customer_id = o.customer_id)
                                 Buffers: shared hit=4
                     ->  Index Scan using accounts_customer_id_key on accounts a  (cost=0.44..3.97 rows=1 width=10) (actual time=0.012..0.012 rows=1 loops=1)
                           Index Cond: (customer_id = c.customer_id)
                           Buffers: shared hit=4
               ->  Index Scan using suppliers_pkey on suppliers s  (cost=0.29..8.31 rows=1 width=37) (actual time=0.004..0.004 rows=1 loops=1)
                    Index Cond: (supplier_id = $0)
                     Buffers: shared hit=3
         ->  Gather  (cost=146541.89..256330.43 rows=34 width=43) (actual time=2771.316..4438.905 rows=10 loops=1)
               Workers Planned: 2
               Params Evaluated: $0, $2
               Workers Launched: 2
               Buffers: shared hit=201675
               ->  Parallel Hash Join  (cost=145541.89..255327.03 rows=14 width=43) (actual time=1175.750..2887.419 rows=17 loops=3)
                     Hash Cond: (pr.product_id = p.product_id)
                     Buffers: shared hit=147620
                     ->  Parallel Seq Scan on prices pr  (cost=0.00..106139.24 rows=1388913 width=10) (actual time=0.059..1472.067 rows=1665948 loops=3)
                           Filter: (price > $2)
                           Rows Removed by Filter: 1666801
                           Buffers: shared hit=54046
                     ->  Parallel Hash  (cost=145541.36..145541.36 rows=42 width=41) (actual time=1031.993..1031.994 rows=34 loops=3)
                           Buckets: 1024  Batches: 1  Memory Usage: 104kB
                           Buffers: shared hit=93458
                           ->  Parallel Seq Scan on products p  (cost=0.00..145541.36 rows=42 width=41) (actual time=427.861..1030.437 rows=34 loops=3)
                                 Filter: (supplier_id = $0)
                                 Rows Removed by Filter: 3333300
                                 Buffers: shared hit=93458
 Planning:
   Buffers: shared hit=463
 Planning Time: 13.130 ms
 JIT:
   Functions: 114
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 11.187 ms, Inlining 1003.024 ms, Optimization 874.837 ms, Emission 530.374 ms, Total 2419.422 ms
 Execution Time: 41710.845 ms
(71 rows)



--Try3
commercedb=# EXPLAIN (ANALYZE, BUFFERS) SELECT c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, p.product_name, pr.price, s.supplier_name, a.balance
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN accounts a ON c.customer_id = a.customer_id
JOIN products p ON p.supplier_id = (SELECT supplier_id FROM suppliers WHERE supplier_name = '0202521e5b58ac90e003a8d0025621c4' LIMIT 1)
JOIN prices pr ON pr.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE o.order_date = '2023-11-21 16:31:21.334746'
  AND pr.price > (SELECT AVG(price) FROM prices)
ORDER BY o.order_date DESC LIMIT 10;
                                                                          QUERY PLAN                                                                          
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=257167.54..1311031.52 rows=10 width=160) (actual time=33920.869..34576.904 rows=10 loops=1)
   Buffers: shared hit=470623 read=1622521
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.024..0.025 rows=1 loops=1)
           Buffers: shared hit=1
           ->  Seq Scan on suppliers  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.016..0.017 rows=1 loops=1)
                 Filter: ((supplier_name)::text = '0202521e5b58ac90e003a8d0025621c4'::text)
                 Buffers: shared hit=1
   InitPlan 2 (returns $2)
     ->  Finalize Aggregate  (cost=107139.47..107139.48 rows=1 width=32) (actual time=1115.680..1115.776 rows=1 loops=1)
           Buffers: shared hit=54055
           ->  Gather  (cost=107139.25..107139.46 rows=2 width=32) (actual time=1115.520..1115.738 rows=3 loops=1)
                 Workers Planned: 2
                 Workers Launched: 2
                 Buffers: shared hit=54055
                 ->  Partial Aggregate  (cost=106139.25..106139.26 rows=1 width=32) (actual time=1064.717..1064.718 rows=1 loops=3)
                       Buffers: shared hit=54055
                       ->  Parallel Seq Scan on prices  (cost=0.00..95722.40 rows=4166740 width=6) (actual time=0.023..373.841 rows=3333333 loops=3)
                             Buffers: shared hit=54055
   ->  Nested Loop  (cost=147543.06..3730680.61 rows=34 width=160) (actual time=33499.386..34155.316 rows=10 loops=1)
         Buffers: shared hit=470623 read=1622521
         ->  Nested Loop  (cost=1001.17..3474349.84 rows=1 width=125) (actual time=31810.592..31810.651 rows=1 loops=1)
               Buffers: shared hit=288320 read=1622521
               ->  Nested Loop  (cost=1000.88..3474341.52 rows=1 width=88) (actual time=31810.539..31810.598 rows=1 loops=1)
                     Buffers: shared hit=288316 read=1622521
                     ->  Nested Loop  (cost=1000.44..3474337.56 rows=1 width=90) (actual time=31810.502..31810.560 rows=1 loops=1)
                           Buffers: shared hit=288312 read=1622521
                           ->  Gather  (cost=1000.00..3474329.10 rows=1 width=20) (actual time=31810.412..31810.470 rows=1 loops=1)
                                 Workers Planned: 2
                                 Workers Launched: 2
                                 Buffers: shared hit=288308 read=1622521
                                 ->  Parallel Seq Scan on orders o  (cost=0.00..3473329.00 rows=1 width=20) (actual time=26084.969..31792.381 rows=0 loops=3)
                                       Filter: (order_date = '2023-11-21 16:31:21.334746'::timestamp without time zone)
                                       Rows Removed by Filter: 100000000
                                       Buffers: shared hit=288308 read=1622521
                           ->  Index Scan using customers_pkey on customers c  (cost=0.44..8.46 rows=1 width=70) (actual time=0.044..0.045 rows=1 loops=1)
                                 Index Cond: (customer_id = o.customer_id)
                                 Buffers: shared hit=4
                     ->  Index Scan using accounts_customer_id_key on accounts a  (cost=0.44..3.97 rows=1 width=10) (actual time=0.021..0.021 rows=1 loops=1)
                           Index Cond: (customer_id = c.customer_id)
                           Buffers: shared hit=4
               ->  Index Scan using suppliers_pkey on suppliers s  (cost=0.29..8.31 rows=1 width=37) (actual time=0.006..0.006 rows=1 loops=1)
                    Index Cond: (supplier_id = $0)
                     Buffers: shared hit=3
         ->  Gather  (cost=146541.89..256330.43 rows=34 width=43) (actual time=1688.788..2344.647 rows=10 loops=1)
               Workers Planned: 2
               Params Evaluated: $0, $2
               Workers Launched: 2
               Buffers: shared hit=182303
               ->  Parallel Hash Join  (cost=145541.89..255327.03 rows=14 width=43) (actual time=557.082..1149.323 rows=12 loops=3)
                     Hash Cond: (pr.product_id = p.product_id)
                     Buffers: shared hit=128248
                     ->  Parallel Seq Scan on prices pr  (cost=0.00..106139.24 rows=1388913 width=10) (actual time=0.038..495.507 rows=1068999 loops=3)
                           Filter: (price > $2)
                           Rows Removed by Filter: 1069201
                           Buffers: shared hit=34674
                     ->  Parallel Hash  (cost=145541.36..145541.36 rows=42 width=41) (actual time=529.957..529.958 rows=34 loops=3)
                           Buckets: 1024  Batches: 1  Memory Usage: 0kB
                           Buffers: shared hit=93458
                           ->  Parallel Seq Scan on products p  (cost=0.00..145541.36 rows=42 width=41) (actual time=234.956..529.799 rows=34 loops=3)
                                 Filter: (supplier_id = $0)
                                 Rows Removed by Filter: 3333300
                                 Buffers: shared hit=93458
 Planning:
   Buffers: shared hit=463
 Planning Time: 17.543 ms
 JIT:
   Functions: 114
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 12.981 ms, Inlining 885.516 ms, Optimization 501.204 ms, Emission 363.491 ms, Total 1763.193 ms
 Execution Time: 34701.184 ms
(71 rows)



-- optimization

-- commercedb=# EXPLAIN (ANALYZE, BUFFERS, VERBOSE) WITH supplier_cte AS (
--     SELECT supplier_id
--     FROM suppliers
--     WHERE supplier_name = '0202521e5b58ac90e003a8d0025621c4'
--     LIMIT 1
-- ),
-- avg_price_cte AS (
--     SELECT AVG(price) AS avg_price
--     FROM prices
-- ),
-- filtered_orders_cte AS (
--     SELECT o.order_id, o.customer_id, o.order_date, o.quantity
--     FROM orders o
--     WHERE o.order_date = '2023-11-21 16:31:21.334746'
-- ),
-- filtered_prices_cte AS (
--     SELECT pr.product_id, pr.price
--     FROM prices pr, avg_price_cte
--     WHERE pr.price > avg_price_cte.avg_price
-- )
-- SELECT c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, 
--        p.product_name, pr.price, s.supplier_name, a.balance
-- FROM customers c
-- JOIN filtered_orders_cte o ON c.customer_id = o.customer_id
-- JOIN accounts a ON c.customer_id = a.customer_id
-- JOIN products p ON p.supplier_id = (SELECT supplier_id FROM supplier_cte)
-- JOIN filtered_prices_cte pr ON pr.product_id = p.product_id
-- JOIN suppliers s ON p.supplier_id = s.supplier_id
-- ORDER BY o.order_date DESC
-- LIMIT 10;

-- Ensure indexes exist
-- CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON Orders (Customer_id);
-- CREATE INDEX IF NOT EXISTS idx_orders_order_date ON Orders (Order_date);
CREATE INDEX IF NOT EXISTS idx_accounts_customer_id ON Accounts (Customer_id);
CREATE INDEX IF NOT EXISTS idx_prices_product_id ON prices (Product_id);
CREATE INDEX IF NOT EXISTS idx_products_supplier_id ON Products (Supplier_id);

commercedb=# CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON Orders (Customer_id);
CREATE INDEX
commercedb=# \d orders
                                            Table "public.orders"
   Column    |            Type             | Collation | Nullable |                 Default                  
-------------+-----------------------------+-----------+----------+------------------------------------------
 order_id    | integer                     |           | not null | nextval('orders_order_id_seq'::regclass)
 order_date  | timestamp without time zone |           |          | 
 quantity    | integer                     |           | not null | 
 customer_id | integer                     |           | not null | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (order_id)
    "idx_orders_customer_id" btree (customer_id)
    "idx_orders_customer_id_order_date" btree (customer_id, order_date)
Foreign-key constraints:
    "orders_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
Referenced by:
    TABLE "orders_products" CONSTRAINT "orders_products_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(order_id)

commercedb=# CREATE INDEX IF NOT EXISTS idx_orders_order_date ON Orders (Order_date);
CREATE INDEX
commercedb=# \d orders
                                            Table "public.orders"
   Column    |            Type             | Collation | Nullable |                 Default                  
-------------+-----------------------------+-----------+----------+------------------------------------------
 order_id    | integer                     |           | not null | nextval('orders_order_id_seq'::regclass)
 order_date  | timestamp without time zone |           |          | 
 quantity    | integer                     |           | not null | 
 customer_id | integer                     |           | not null | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (order_id)
    "idx_orders_customer_id" btree (customer_id)
    "idx_orders_customer_id_order_date" btree (customer_id, order_date)
    "idx_orders_order_date" btree (order_date)
Foreign-key constraints:
    "orders_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
Referenced by:
    TABLE "orders_products" CONSTRAINT "orders_products_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(order_id)

--corrected Orders table after dropping excess indexes
commercedb=# \d orders
                                            Table "public.orders"
   Column    |            Type             | Collation | Nullable |                 Default                  
-------------+-----------------------------+-----------+----------+------------------------------------------
 order_id    | integer                     |           | not null | nextval('orders_order_id_seq'::regclass)
 order_date  | timestamp without time zone |           |          | 
 quantity    | integer                     |           | not null | 
 customer_id | integer                     |           | not null | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (order_id)
    "idx_orders_customer_id_order_date" btree (customer_id, order_date)
Foreign-key constraints:
    "orders_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
Referenced by:
    TABLE "orders_products" CONSTRAINT "orders_products_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(order_id)



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

commercedb=# CREATE INDEX IF NOT EXISTS idx_accounts_customer_id ON Accounts (Customer_id);
CREATE INDEX
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
    "idx_accounts_customer_id" btree (customer_id)
Foreign-key constraints:
    "accounts_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES customers(customer_id)

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

commercedb=# CREATE INDEX IF NOT EXISTS idx_prices_product_id ON prices (Product_id);
CREATE INDEX
commercedb=# \d prices
                                    Table "public.prices"
   Column   |     Type      | Collation | Nullable |                 Default                  
------------+---------------+-----------+----------+------------------------------------------
 price_id   | integer       |           | not null | nextval('prices_price_id_seq'::regclass)
 product_id | integer       |           | not null | 
 price      | numeric(10,2) |           | not null | 
Indexes:
    "prices_pkey" PRIMARY KEY, btree (price_id)
    "idx_prices_product_id" btree (product_id)
Foreign-key constraints:
    "prices_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(product_id)

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
Referenced by:
    TABLE "orders_products" CONSTRAINT "orders_products_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(product_id)
    TABLE "prices" CONSTRAINT "prices_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(product_id)

commercedb=# CREATE INDEX IF NOT EXISTS idx_products_supplier_id ON Products (Supplier_id);
CREATE INDEX
commercedb=# \d products
                                           Table "public.products"
    Column    |          Type          | Collation | Nullable |                   Default                    
--------------+------------------------+-----------+----------+----------------------------------------------
 product_id   | integer                |           | not null | nextval('products_product_id_seq'::regclass)
 supplier_id  | integer                |           | not null | 
 product_name | character varying(100) |           | not null | 
Indexes:
    "products_pkey" PRIMARY KEY, btree (product_id)
    "idx_products_supplier_id" btree (supplier_id)
Foreign-key constraints:
    "products_supplier_id_fkey" FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
Referenced by:
    TABLE "orders_products" CONSTRAINT "orders_products_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(product_id)
    TABLE "prices" CONSTRAINT "prices_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(product_id)



--Post Optimization

--Try1

                                                                             QUERY PLAN                                                                              
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=109626.18..110006.25 rows=10 width=160) (actual time=1062.491..1088.382 rows=10 loops=1)
   Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, p.product_name, pr.price, s.supplier_name, a.balance
   Buffers: shared hit=54170
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.034..0.035 rows=1 loops=1)
           Output: suppliers.supplier_id
           Buffers: shared hit=1
           ->  Seq Scan on public.suppliers  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.028..0.028 rows=1 loops=1)
                 Output: suppliers.supplier_id
                 Filter: ((suppliers.supplier_name)::text = '0202521e5b58ac90e003a8d0025621c4'::text)
                 Buffers: shared hit=1
   InitPlan 2 (returns $2)
     ->  Finalize Aggregate  (cost=107138.56..107138.57 rows=1 width=32) (actual time=1034.388..1059.795 rows=1 loops=1)
           Output: avg(prices.price)
           Buffers: shared hit=54055
           ->  Gather  (cost=107138.34..107138.55 rows=2 width=32) (actual time=1034.188..1059.753 rows=3 loops=1)
                 Output: (PARTIAL avg(prices.price))
                 Workers Planned: 2
                 Workers Launched: 2
                 Buffers: shared hit=54055
                 ->  Partial Aggregate  (cost=106138.34..106138.35 rows=1 width=32) (actual time=1010.917..1010.918 rows=1 loops=3)
                       Output: PARTIAL avg(prices.price)
                       Buffers: shared hit=54055
                       Worker 0:  actual time=999.490..999.491 rows=1 loops=1
                         JIT:
                           Functions: 8
                           Options: Inlining false, Optimization false, Expressions true, Deforming true
                           Timing: Generation 0.835 ms, Inlining 0.000 ms, Optimization 0.407 ms, Emission 8.332 ms, Total 9.574 ms
                         Buffers: shared hit=16209
                       Worker 1:  actual time=999.492..999.492 rows=1 loops=1
                         JIT:
                           Functions: 8
                           Options: Inlining false, Optimization false, Expressions true, Deforming true
                           Timing: Generation 0.835 ms, Inlining 0.000 ms, Optimization 0.407 ms, Emission 8.333 ms, Total 9.576 ms
                         Buffers: shared hit=13642
                       ->  Parallel Seq Scan on public.prices  (cost=0.00..95721.67 rows=4166667 width=6) (actual time=0.019..376.674 rows=3333333 loops=3)
                             Output: prices.price_id, prices.product_id, prices.price
                             Buffers: shared hit=54055
                             Worker 0:  actual time=0.028..375.510 rows=2998665 loops=1
                               Buffers: shared hit=16209
                             Worker 1:  actual time=0.027..375.907 rows=2523770 loops=1
                               Buffers: shared hit=13642
 ->  Nested Loop  (cost=2.61..1294.84 rows=34 width=160) (actual time=1034.701..1035.181 rows=10 loops=1)
         Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, p.product_name, pr.price, s.supplier_name, a.balance
         Buffers: shared hit=54170
         ->  Nested Loop  (cost=1.74..29.33 rows=1 width=125) (actual time=0.213..0.216 rows=1 loops=1)
               Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, a.balance, s.supplier_name, s.supplier_id
               Buffers: shared hit=17
               ->  Nested Loop  (cost=1.45..21.01 rows=1 width=88) (actual time=0.154..0.156 rows=1 loops=1)
                     Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, a.balance
                     Inner Unique: true
                     Buffers: shared hit=13
                     ->  Nested Loop  (cost=1.01..17.05 rows=1 width=90) (actual time=0.116..0.117 rows=1 loops=1)
                           Output: c.customer_name, c.contact_info, c.customer_id, o.order_id, o.order_date, o.quantity, o.customer_id
                           Inner Unique: true
                           Buffers: shared hit=9
                           ->  Index Scan using idx_orders_order_date on public.orders o  (cost=0.57..8.59 rows=1 width=20) (actual time=0.053..0.054 rows=1 loops=1)
                                 Output: o.order_id, o.order_date, o.quantity, o.customer_id
                                 Index Cond: (o.order_date = '2023-11-21 16:31:21.334746'::timestamp without time zone)
                                 Buffers: shared hit=5
                           ->  Index Scan using customers_pkey on public.customers c  (cost=0.44..8.46 rows=1 width=70) (actual time=0.047..0.047 rows=1 loops=1)
                                 Output: c.customer_id, c.customer_name, c.contact_info, c.customer_address
                                 Index Cond: (c.customer_id = o.customer_id)
                                 Buffers: shared hit=4
                     ->  Index Scan using accounts_customer_id_key on public.accounts a  (cost=0.44..3.97 rows=1 width=10) (actual time=0.031..0.031 rows=1 loops=1)
                           Output: a.account_id, a.balance, a.customer_id
                           Index Cond: (a.customer_id = c.customer_id)
                           Buffers: shared hit=4
               ->  Index Scan using suppliers_pkey on public.suppliers s  (cost=0.29..8.31 rows=1 width=37) (actual time=0.011..0.011 rows=1 loops=1)
                     Output: s.supplier_id, s.supplier_name, s.contact_info
                     Index Cond: (s.supplier_id = $0)
                     Buffers: shared hit=3
         ->  Nested Loop  (cost=0.87..1265.16 rows=34 width=43) (actual time=1034.477..1034.952 rows=10 loops=1)
               Output: p.product_name, p.supplier_id, pr.price
               Buffers: shared hit=54153
               ->  Index Scan using idx_products_supplier_id on public.products p  (cost=0.43..410.20 rows=101 width=41) (actual time=0.042..0.305 rows=19 loops=1)
                     Output: p.product_id, p.supplier_id, p.product_name
                     Index Cond: (p.supplier_id = $0)
                     Buffers: shared hit=22
               ->  Index Scan using idx_prices_product_id on public.prices pr  (cost=0.43..8.46 rows=1 width=10) (actual time=54.453..54.453 rows=1 loops=19)
                     Output: pr.price_id, pr.product_id, pr.price
                     Index Cond: (pr.product_id = p.product_id)
                     Filter: (pr.price > $2)
                     Rows Removed by Filter: 0
                                         Buffers: shared hit=54131
 Planning:
   Buffers: shared hit=538
 Planning Time: 21.030 ms
 JIT:
   Functions: 57
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 4.519 ms, Inlining 0.000 ms, Optimization 1.808 ms, Emission 43.566 ms, Total 49.893 ms
 Execution Time: 1161.067 ms
(93 rows)


--Try2

                                                                              QUERY PLAN                                                                              
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=109626.18..110006.25 rows=10 width=160) (actual time=1061.755..1087.863 rows=10 loops=1)
   Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, p.product_name, pr.price, s.supplier_name, a.balance
   Buffers: shared hit=54170
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.022..0.023 rows=1 loops=1)
           Output: suppliers.supplier_id
           Buffers: shared hit=1
           ->  Seq Scan on public.suppliers  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.019..0.020 rows=1 loops=1)
                 Output: suppliers.supplier_id
                 Filter: ((suppliers.supplier_name)::text = '0202521e5b58ac90e003a8d0025621c4'::text)
                 Buffers: shared hit=1
   InitPlan 2 (returns $2)
     ->  Finalize Aggregate  (cost=107138.56..107138.57 rows=1 width=32) (actual time=1033.951..1059.697 rows=1 loops=1)
           Output: avg(prices.price)
           Buffers: shared hit=54055
           ->  Gather  (cost=107138.34..107138.55 rows=2 width=32) (actual time=1033.691..1059.647 rows=3 loops=1)
                 Output: (PARTIAL avg(prices.price))
                 Workers Planned: 2
                 Workers Launched: 2
                 Buffers: shared hit=54055
                 ->  Partial Aggregate  (cost=106138.34..106138.35 rows=1 width=32) (actual time=1010.459..1010.460 rows=1 loops=3)
                       Output: PARTIAL avg(prices.price)
                       Buffers: shared hit=54055
                       Worker 0:  actual time=999.027..999.028 rows=1 loops=1
                         JIT:
                           Functions: 8
                           Options: Inlining false, Optimization false, Expressions true, Deforming true
                           Timing: Generation 0.853 ms, Inlining 0.000 ms, Optimization 0.399 ms, Emission 8.504 ms, Total 9.756 ms
                         Buffers: shared hit=13944
                       Worker 1:  actual time=999.037..999.038 rows=1 loops=1
                         JIT:
                           Functions: 8
                           Options: Inlining false, Optimization false, Expressions true, Deforming true
                           Timing: Generation 0.856 ms, Inlining 0.000 ms, Optimization 0.399 ms, Emission 8.377 ms, Total 9.632 ms
                         Buffers: shared hit=14055
                       ->  Parallel Seq Scan on public.prices  (cost=0.00..95721.67 rows=4166667 width=6) (actual time=0.017..378.011 rows=3333333 loops=3)
                             Output: prices.price_id, prices.product_id, prices.price
                             Buffers: shared hit=54055
                             Worker 0:  actual time=0.024..378.075 rows=2579640 loops=1
                               Buffers: shared hit=13944
                             Worker 1:  actual time=0.023..379.505 rows=2600175 loops=1
                               Buffers: shared hit=14055
 ->  Nested Loop  (cost=2.61..1294.84 rows=34 width=160) (actual time=1034.226..1034.583 rows=10 loops=1)
         Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, p.product_name, pr.price, s.supplier_name, a.balance
         Buffers: shared hit=54170
         ->  Nested Loop  (cost=1.74..29.33 rows=1 width=125) (actual time=0.196..0.199 rows=1 loops=1)
               Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, a.balance, s.supplier_name, s.supplier_id
               Buffers: shared hit=17
               ->  Nested Loop  (cost=1.45..21.01 rows=1 width=88) (actual time=0.157..0.158 rows=1 loops=1)
                     Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, a.balance
                     Inner Unique: true
                     Buffers: shared hit=13
                     ->  Nested Loop  (cost=1.01..17.05 rows=1 width=90) (actual time=0.117..0.118 rows=1 loops=1)
                           Output: c.customer_name, c.contact_info, c.customer_id, o.order_id, o.order_date, o.quantity, o.customer_id
                           Inner Unique: true
                           Buffers: shared hit=9
                           ->  Index Scan using idx_orders_order_date on public.orders o  (cost=0.57..8.59 rows=1 width=20) (actual time=0.053..0.054 rows=1 loops=1)
                                 Output: o.order_id, o.order_date, o.quantity, o.customer_id
                                 Index Cond: (o.order_date = '2023-11-21 16:31:21.334746'::timestamp without time zone)
                                 Buffers: shared hit=5
                           ->  Index Scan using customers_pkey on public.customers c  (cost=0.44..8.46 rows=1 width=70) (actual time=0.048..0.048 rows=1 loops=1)
                                 Output: c.customer_id, c.customer_name, c.contact_info, c.customer_address
                                 Index Cond: (c.customer_id = o.customer_id)
                                 Buffers: shared hit=4
                     ->  Index Scan using accounts_customer_id_key on public.accounts a  (cost=0.44..3.97 rows=1 width=10) (actual time=0.032..0.032 rows=1 loops=1)
                           Output: a.account_id, a.balance, a.customer_id
                           Index Cond: (a.customer_id = c.customer_id)
                           Buffers: shared hit=4
               ->  Index Scan using suppliers_pkey on public.suppliers s  (cost=0.29..8.31 rows=1 width=37) (actual time=0.008..0.008 rows=1 loops=1)
                     Output: s.supplier_id, s.supplier_name, s.contact_info
                     Index Cond: (s.supplier_id = $0)
                     Buffers: shared hit=3
         ->  Nested Loop  (cost=0.87..1265.16 rows=34 width=43) (actual time=1034.022..1034.375 rows=10 loops=1)
               Output: p.product_name, p.supplier_id, pr.price
               Buffers: shared hit=54153
               ->  Index Scan using idx_products_supplier_id on public.products p  (cost=0.43..410.20 rows=101 width=41) (actual time=0.033..0.228 rows=19 loops=1)
                     Output: p.product_id, p.supplier_id, p.product_name
                     Index Cond: (p.supplier_id = $0)
                     Buffers: shared hit=22
               ->  Index Scan using idx_prices_product_id on public.prices pr  (cost=0.43..8.46 rows=1 width=10) (actual time=54.427..54.428 rows=1 loops=19)
                     Output: pr.price_id, pr.product_id, pr.price
                     Index Cond: (pr.product_id = p.product_id)
                     Filter: (pr.price > $2)
                     Rows Removed by Filter: 0
                     Buffers: shared hit=54131
 Planning:
   Buffers: shared hit=538
 Planning Time: 24.397 ms
 JIT:
   Functions: 57
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 4.581 ms, Inlining 0.000 ms, Optimization 1.794 ms, Emission 43.487 ms, Total 49.862 ms
 Execution Time: 1155.694 ms
(93 rows)


--Try3

                                                                              QUERY PLAN                                                                              
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=109626.18..110006.25 rows=10 width=160) (actual time=1054.873..1080.894 rows=10 loops=1)
   Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, p.product_name, pr.price, s.supplier_name, a.balance
   Buffers: shared hit=54170
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.036..0.037 rows=1 loops=1)
           Output: suppliers.supplier_id
           Buffers: shared hit=1
           ->  Seq Scan on public.suppliers  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.031..0.031 rows=1 loops=1)
                 Output: suppliers.supplier_id
                 Filter: ((suppliers.supplier_name)::text = '0202521e5b58ac90e003a8d0025621c4'::text)
                 Buffers: shared hit=1
   InitPlan 2 (returns $2)
     ->  Finalize Aggregate  (cost=107138.56..107138.57 rows=1 width=32) (actual time=1030.834..1056.466 rows=1 loops=1)
           Output: avg(prices.price)
           Buffers: shared hit=54055
           ->  Gather  (cost=107138.34..107138.55 rows=2 width=32) (actual time=1030.686..1056.436 rows=3 loops=1)
                 Output: (PARTIAL avg(prices.price))
                 Workers Planned: 2
                 Workers Launched: 2
                 Buffers: shared hit=54055
                 ->  Partial Aggregate  (cost=106138.34..106138.35 rows=1 width=32) (actual time=1007.693..1007.694 rows=1 loops=3)
                       Output: PARTIAL avg(prices.price)
                       Buffers: shared hit=54055
                       Worker 0:  actual time=996.390..996.391 rows=1 loops=1
                         JIT:
                           Functions: 8
                           Options: Inlining false, Optimization false, Expressions true, Deforming true
                           Timing: Generation 0.792 ms, Inlining 0.000 ms, Optimization 0.392 ms, Emission 8.980 ms, Total 10.164 ms
                         Buffers: shared hit=13496
                       Worker 1:  actual time=996.373..996.374 rows=1 loops=1
                         JIT:
                           Functions: 8
                           Options: Inlining false, Optimization false, Expressions true, Deforming true
                           Timing: Generation 0.823 ms, Inlining 0.000 ms, Optimization 0.395 ms, Emission 8.983 ms, Total 10.201 ms
                         Buffers: shared hit=13920
                       ->  Parallel Seq Scan on public.prices  (cost=0.00..95721.67 rows=4166667 width=6) (actual time=0.020..377.118 rows=3333333 loops=3)
                             Output: prices.price_id, prices.product_id, prices.price
                             Buffers: shared hit=54055
                             Worker 0:  actual time=0.027..380.619 rows=2496760 loops=1
                               Buffers: shared hit=13496
                             Worker 1:  actual time=0.028..375.941 rows=2575200 loops=1
                               Buffers: shared hit=13920
 ->  Nested Loop  (cost=2.61..1294.84 rows=34 width=160) (actual time=1031.165..1031.550 rows=10 loops=1)
         Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, p.product_name, pr.price, s.supplier_name, a.balance
         Buffers: shared hit=54170
         ->  Nested Loop  (cost=1.74..29.33 rows=1 width=125) (actual time=0.248..0.251 rows=1 loops=1)
               Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, a.balance, s.supplier_name, s.supplier_id
               Buffers: shared hit=17
               ->  Nested Loop  (cost=1.45..21.01 rows=1 width=88) (actual time=0.191..0.193 rows=1 loops=1)
                     Output: c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, a.balance
                     Inner Unique: true
                     Buffers: shared hit=13
                     ->  Nested Loop  (cost=1.01..17.05 rows=1 width=90) (actual time=0.146..0.147 rows=1 loops=1)
                           Output: c.customer_name, c.contact_info, c.customer_id, o.order_id, o.order_date, o.quantity, o.customer_id
                           Inner Unique: true
                           Buffers: shared hit=9
                           ->  Index Scan using idx_orders_order_date on public.orders o  (cost=0.57..8.59 rows=1 width=20) (actual time=0.068..0.068 rows=1 loops=1)
                                 Output: o.order_id, o.order_date, o.quantity, o.customer_id
                                 Index Cond: (o.order_date = '2023-11-21 16:31:21.334746'::timestamp without time zone)
                                 Buffers: shared hit=5
                           ->  Index Scan using customers_pkey on public.customers c  (cost=0.44..8.46 rows=1 width=70) (actual time=0.055..0.055 rows=1 loops=1)
                                 Output: c.customer_id, c.customer_name, c.contact_info, c.customer_address
                                 Index Cond: (c.customer_id = o.customer_id)
                                 Buffers: shared hit=4
                     ->  Index Scan using accounts_customer_id_key on public.accounts a  (cost=0.44..3.97 rows=1 width=10) (actual time=0.033..0.034 rows=1 loops=1)
                           Output: a.account_id, a.balance, a.customer_id
                           Index Cond: (a.customer_id = c.customer_id)
                           Buffers: shared hit=4
               ->  Index Scan using suppliers_pkey on public.suppliers s  (cost=0.29..8.31 rows=1 width=37) (actual time=0.009..0.009 rows=1 loops=1)
                     Output: s.supplier_id, s.supplier_name, s.contact_info
                     Index Cond: (s.supplier_id = $0)
                     Buffers: shared hit=3
         ->  Nested Loop  (cost=0.87..1265.16 rows=34 width=43) (actual time=1030.908..1031.288 rows=10 loops=1)
               Output: p.product_name, p.supplier_id, pr.price
               Buffers: shared hit=54153
               ->  Index Scan using idx_products_supplier_id on public.products p  (cost=0.43..410.20 rows=101 width=41) (actual time=0.033..0.242 rows=19 loops=1)
                     Output: p.product_id, p.supplier_id, p.product_name
                     Index Cond: (p.supplier_id = $0)
                     Buffers: shared hit=22
               ->  Index Scan using idx_prices_product_id on public.prices pr  (cost=0.43..8.46 rows=1 width=10) (actual time=54.263..54.264 rows=1 loops=19)
                     Output: pr.price_id, pr.product_id, pr.price
                     Index Cond: (pr.product_id = p.product_id)
                     Filter: (pr.price > $2)
                     Rows Removed by Filter: 0
                     Buffers: shared hit=54131
 Planning:
   Buffers: shared hit=538
 Planning Time: 41.183 ms
 JIT:
   Functions: 57
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 3.667 ms, Inlining 0.000 ms, Optimization 1.637 ms, Emission 40.916 ms, Total 46.220 ms
 Execution Time: 1126.423 ms
(93 rows)

/*
  By creating indexes on all the foreign keys used by the join operations in the query, we have significantly reduced the query
  execution and as such improved the performance.
*/

--Further Optimization


CREATE MATERIALIZED VIEW avg_price AS
SELECT AVG(price) AS avg_price FROM prices;

commercedb=# \d+ avg_price
                                   Materialized view "public.avg_price"
  Column   |  Type   | Collation | Nullable | Default | Storage | Compression | Stats target | Description 
-----------+---------+-----------+----------+---------+---------+-------------+--------------+-------------
 avg_price | numeric |           |          |         | main    |             |              | 
View definition:
 SELECT avg(price) AS avg_price
   FROM prices;
Access method: heap

EXPLAIN (ANALYZE, BUFFERS) 
SELECT c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, 
       p.product_name, pr.price, s.supplier_name, a.balance
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN accounts a ON c.customer_id = a.customer_id
JOIN products p ON p.supplier_id = (
    SELECT supplier_id 
    FROM suppliers 
    WHERE supplier_name = '0202521e5b58ac90e003a8d0025621c4' 
    LIMIT 1
)
JOIN prices pr ON pr.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
JOIN avg_price ap ON pr.price > ap.avg_price        --Join with Materialized View
WHERE o.order_date = '2023-11-21 16:31:21.334746'
ORDER BY o.order_date DESC 
LIMIT 10;



--Try1
commercedb=# EXPLAIN (ANALYZE, BUFFERS) 
SELECT c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, 
       p.product_name, pr.price, s.supplier_name, a.balance
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN accounts a ON c.customer_id = a.customer_id
JOIN products p ON p.supplier_id = (
    SELECT supplier_id 
    FROM suppliers 
    WHERE supplier_name = '0202521e5b58ac90e003a8d0025621c4' 
    LIMIT 1
)
JOIN prices pr ON pr.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
JOIN avg_price ap ON pr.price > ap.avg_price        --Join with Materialized View
WHERE o.order_date = '2023-11-21 16:31:21.334746'
ORDER BY o.order_date DESC 
LIMIT 10;
                                                                             QUERY PLAN                                                                             
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=2487.04..3724.11 rows=10 width=160) (actual time=0.394..1.644 rows=10 loops=1)
   Buffers: shared hit=112
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.017..0.019 rows=1 loops=1)
           Buffers: shared hit=1
           ->  Seq Scan on suppliers  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.017..0.017 rows=1 loops=1)
                 Filter: ((supplier_name)::text = '0202521e5b58ac90e003a8d0025621c4'::text)
                 Buffers: shared hit=1
   ->  Nested Loop  (cost=2.04..5664203.06 rows=45787 width=160) (actual time=0.393..1.638 rows=10 loops=1)
         Join Filter: (pr.price > ap.avg_price)
         Rows Removed by Join Filter: 9
         Buffers: shared hit=112
         ->  Nested Loop  (cost=2.04..5662115.66 rows=101 width=160) (actual time=0.353..1.561 rows=19 loops=1)
               Buffers: shared hit=111
               ->  Nested Loop  (cost=1.17..5660849.74 rows=1 width=125) (actual time=0.253..0.256 rows=1 loops=1)
                     Buffers: shared hit=13
                     ->  Nested Loop  (cost=0.88..5660841.42 rows=1 width=88) (actual time=0.208..0.210 rows=1 loops=1)
                           Buffers: shared hit=9
                           ->  Nested Loop  (cost=0.44..5660837.46 rows=1 width=90) (actual time=0.146..0.147 rows=1 loops=1)
                                 Buffers: shared hit=5
                                 ->  Seq Scan on orders o  (cost=0.00..5660829.00 rows=1 width=20) (actual time=0.040..0.040 rows=1 loops=1)
                                       Filter: (order_date = '2023-11-21 16:31:21.334746'::timestamp without time zone)
                                       Buffers: shared hit=1
                                 ->  Index Scan using customers_pkey on customers c  (cost=0.44..8.46 rows=1 width=70) (actual time=0.102..0.102 rows=1 loops=1)
                                       Index Cond: (customer_id = o.customer_id)
                                       Buffers: shared hit=4
                           ->  Index Scan using accounts_customer_id_key on accounts a  (cost=0.44..3.97 rows=1 width=10) (actual time=0.060..0.060 rows=1 loops=1)
                                 Index Cond: (customer_id = c.customer_id)
                                 Buffers: shared hit=4
                     ->  Index Scan using suppliers_pkey on suppliers s  (cost=0.29..8.31 rows=1 width=37) (actual time=0.024..0.025 rows=1 loops=1)
                           Index Cond: (supplier_id = $0)
                           Buffers: shared hit=3
               ->  Nested Loop  (cost=0.87..1264.91 rows=101 width=43) (actual time=0.098..1.294 rows=19 loops=1)
                     Buffers: shared hit=98
                     ->  Index Scan using idx_products_supplier_id on products p  (cost=0.43..410.20 rows=101 width=41) (actual time=0.071..0.522 rows=19 loops=1)
                           Index Cond: (supplier_id = $0)
                           Buffers: shared hit=22
                     ->  Index Scan using idx_prices_product_id on prices pr  (cost=0.43..8.45 rows=1 width=10) (actual time=0.038..0.039 rows=1 loops=19)
                           Index Cond: (product_id = p.product_id)
                           Buffers: shared hit=76
         ->  Materialize  (cost=0.00..30.40 rows=1360 width=32) (actual time=0.002..0.002 rows=1 loops=19)
               Buffers: shared hit=1
               ->  Seq Scan on avg_price ap  (cost=0.00..23.60 rows=1360 width=32) (actual time=0.022..0.022 rows=1 loops=1)
                     Buffers: shared hit=1
 Planning:
   Buffers: shared hit=579
 Planning Time: 7.609 ms
 Execution Time: 1.903 ms
(48 rows)





--Try2
commercedb=# EXPLAIN (ANALYZE, BUFFERS) 
SELECT c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, 
       p.product_name, pr.price, s.supplier_name, a.balance
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN accounts a ON c.customer_id = a.customer_id
JOIN products p ON p.supplier_id = (
    SELECT supplier_id 
    FROM suppliers 
    WHERE supplier_name = '0202521e5b58ac90e003a8d0025621c4' 
    LIMIT 1
)
JOIN prices pr ON pr.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
JOIN avg_price ap ON pr.price > ap.avg_price        --Join with Materialized View
WHERE o.order_date = '2023-11-21 16:31:21.334746'
ORDER BY o.order_date DESC 
LIMIT 10;
                                                                            QUERY PLAN                                                                             
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=2487.04..3724.11 rows=10 width=160) (actual time=0.785..2.703 rows=10 loops=1)
   Buffers: shared hit=112
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.032..0.034 rows=1 loops=1)
           Buffers: shared hit=1
           ->  Seq Scan on suppliers  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.031..0.032 rows=1 loops=1)
                 Filter: ((supplier_name)::text = '0202521e5b58ac90e003a8d0025621c4'::text)
                 Buffers: shared hit=1
   ->  Nested Loop  (cost=2.04..5664203.06 rows=45787 width=160) (actual time=0.783..2.694 rows=10 loops=1)
         Join Filter: (pr.price > ap.avg_price)
         Rows Removed by Join Filter: 9
         Buffers: shared hit=112
         ->  Nested Loop  (cost=2.04..5662115.66 rows=101 width=160) (actual time=0.705..2.578 rows=19 loops=1)
               Buffers: shared hit=111
               ->  Nested Loop  (cost=1.17..5660849.74 rows=1 width=125) (actual time=0.480..0.483 rows=1 loops=1)
                     Buffers: shared hit=13
                     ->  Nested Loop  (cost=0.88..5660841.42 rows=1 width=88) (actual time=0.393..0.395 rows=1 loops=1)
                           Buffers: shared hit=9
                           ->  Nested Loop  (cost=0.44..5660837.46 rows=1 width=90) (actual time=0.270..0.271 rows=1 loops=1)
                                 Buffers: shared hit=5
                                 ->  Seq Scan on orders o  (cost=0.00..5660829.00 rows=1 width=20) (actual time=0.082..0.083 rows=1 loops=1)
                                       Filter: (order_date = '2023-11-21 16:31:21.334746'::timestamp without time zone)
                                       Buffers: shared hit=1
                                 ->  Index Scan using customers_pkey on customers c  (cost=0.44..8.46 rows=1 width=70) (actual time=0.179..0.179 rows=1 loops=1)
                                       Index Cond: (customer_id = o.customer_id)
                                       Buffers: shared hit=4
                           ->  Index Scan using accounts_customer_id_key on accounts a  (cost=0.44..3.97 rows=1 width=10) (actual time=0.118..0.118 rows=1 loops=1)
                                 Index Cond: (customer_id = c.customer_id)
                                 Buffers: shared hit=4
                     ->  Index Scan using suppliers_pkey on suppliers s  (cost=0.29..8.31 rows=1 width=37) (actual time=0.047..0.047 rows=1 loops=1)
                           Index Cond: (supplier_id = $0)
                           Buffers: shared hit=3
               ->  Nested Loop  (cost=0.87..1264.91 rows=101 width=43) (actual time=0.221..2.082 rows=19 loops=1)
                     Buffers: shared hit=98
                     ->  Index Scan using idx_products_supplier_id on products p  (cost=0.43..410.20 rows=101 width=41) (actual time=0.134..0.892 rows=19 loops=1)
                           Index Cond: (supplier_id = $0)
                           Buffers: shared hit=22
                     ->  Index Scan using idx_prices_product_id on prices pr  (cost=0.43..8.45 rows=1 width=10) (actual time=0.060..0.060 rows=1 loops=19)
                           Index Cond: (product_id = p.product_id)
                           Buffers: shared hit=76
         ->  Materialize  (cost=0.00..30.40 rows=1360 width=32) (actual time=0.003..0.003 rows=1 loops=19)
               Buffers: shared hit=1
               Buffers: shared hit=1
               ->  Seq Scan on avg_price ap  (cost=0.00..23.60 rows=1360 width=32) (actual time=0.042..0.043 rows=1 loops=1)
                     Buffers: shared hit=1
 Planning:
   Buffers: shared hit=579
 Planning Time: 10.084 ms
 Execution Time: 3.365 ms
(48 rows)

--Try3
commercedb=# EXPLAIN (ANALYZE, BUFFERS) 
SELECT c.customer_name, c.contact_info, o.order_id, o.order_date, o.quantity, 
       p.product_name, pr.price, s.supplier_name, a.balance
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN accounts a ON c.customer_id = a.customer_id
JOIN products p ON p.supplier_id = (
    SELECT supplier_id 
    FROM suppliers 
    WHERE supplier_name = '0202521e5b58ac90e003a8d0025621c4' 
    LIMIT 1
)
JOIN prices pr ON pr.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
JOIN avg_price ap ON pr.price > ap.avg_price        --Join with Materialized View
WHERE o.order_date = '2023-11-21 16:31:21.334746'
ORDER BY o.order_date DESC 
LIMIT 10;
                                                                            QUERY PLAN                                                                             
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=2487.04..3724.11 rows=10 width=160) (actual time=0.791..2.732 rows=10 loops=1)
   Buffers: shared hit=112
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.033..0.035 rows=1 loops=1)
           Buffers: shared hit=1
           ->  Seq Scan on suppliers  (cost=0.00..2485.00 rows=1 width=4) (actual time=0.032..0.033 rows=1 loops=1)
                 Filter: ((supplier_name)::text = '0202521e5b58ac90e003a8d0025621c4'::text)
                 Buffers: shared hit=1
   ->  Nested Loop  (cost=2.04..5664203.06 rows=45787 width=160) (actual time=0.789..2.722 rows=10 loops=1)
         Join Filter: (pr.price > ap.avg_price)
         Rows Removed by Join Filter: 9
         Buffers: shared hit=112
         ->  Nested Loop  (cost=2.04..5662115.66 rows=101 width=160) (actual time=0.714..2.608 rows=19 loops=1)
               Buffers: shared hit=111
               ->  Nested Loop  (cost=1.17..5660849.74 rows=1 width=125) (actual time=0.531..0.534 rows=1 loops=1)
                     Buffers: shared hit=13
                     ->  Nested Loop  (cost=0.88..5660841.42 rows=1 width=88) (actual time=0.444..0.446 rows=1 loops=1)
                           Buffers: shared hit=9
                           ->  Nested Loop  (cost=0.44..5660837.46 rows=1 width=90) (actual time=0.319..0.320 rows=1 loops=1)
                                 Buffers: shared hit=5
                                 ->  Seq Scan on orders o  (cost=0.00..5660829.00 rows=1 width=20) (actual time=0.095..0.096 rows=1 loops=1)
                                       Filter: (order_date = '2023-11-21 16:31:21.334746'::timestamp without time zone)
                                       Buffers: shared hit=1
                                 ->  Index Scan using customers_pkey on customers c  (cost=0.44..8.46 rows=1 width=70) (actual time=0.213..0.213 rows=1 loops=1)
                                       Index Cond: (customer_id = o.customer_id)
                                       Buffers: shared hit=4
                           ->  Index Scan using accounts_customer_id_key on accounts a  (cost=0.44..3.97 rows=1 width=10) (actual time=0.119..0.119 rows=1 loops=1)
                                 Index Cond: (customer_id = c.customer_id)
                                 Buffers: shared hit=4
                     ->  Index Scan using suppliers_pkey on suppliers s  (cost=0.29..8.31 rows=1 width=37) (actual time=0.047..0.047 rows=1 loops=1)
                           Index Cond: (supplier_id = $0)
                           Buffers: shared hit=3
               ->  Nested Loop  (cost=0.87..1264.91 rows=101 width=43) (actual time=0.179..2.041 rows=19 loops=1)
                     Buffers: shared hit=98
                     ->  Index Scan using idx_products_supplier_id on products p  (cost=0.43..410.20 rows=101 width=41) (actual time=0.131..0.853 rows=19 loops=1)
                           Index Cond: (supplier_id = $0)
                           Buffers: shared hit=22
                     ->  Index Scan using idx_prices_product_id on prices pr  (cost=0.43..8.45 rows=1 width=10) (actual time=0.060..0.060 rows=1 loops=19)
                           Index Cond: (product_id = p.product_id)
                           Buffers: shared hit=76
         ->  Materialize  (cost=0.00..30.40 rows=1360 width=32) (actual time=0.003..0.003 rows=1 loops=19)
               Buffers: shared hit=1
               ->  Seq Scan on avg_price ap  (cost=0.00..23.60 rows=1360 width=32) (actual time=0.040..0.042 rows=1 loops=1)
                     Buffers: shared hit=1
 Planning:
   Buffers: shared hit=579
 Planning Time: 11.753 ms
 Execution Time: 3.244 ms
(48 rows)
