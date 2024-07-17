
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
