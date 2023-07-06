/* TPC-DS query16.tpl 0.25 */
SELECT  COUNT(distinct cs_order_number) AS "order count"
       ,SUM(cs_ext_ship_cost)           AS "total shipping cost"
       ,SUM(cs_net_profit)              AS "total net profit"
FROM catalog_sales cs1 , date_dim , customer_address , call_center
WHERE d_date BETWEEN '2000-2-01' AND dateadd(day, 60, cast('2000-2-01' AS date))
AND cs1.cs_ship_date_sk = d_date_sk
AND cs1.cs_ship_addr_sk = ca_address_sk
AND ca_state = 'AL'
AND cs1.cs_call_center_sk = cc_call_center_sk
AND cc_county IN ('Dauphin County', 'Levy County', 'Luce County', 'Jackson County', 'Daviess County' )
AND exists (
SELECT  *
FROM catalog_sales cs2
WHERE cs1.cs_order_number = cs2.cs_order_number
AND cs1.cs_warehouse_sk <> cs2.cs_warehouse_sk) AND not exists(
SELECT  *
FROM catalog_returns cr1
WHERE cs1.cs_order_number = cr1.cr_order_number)
ORDER BY COUNT(distinct cs_order_number);