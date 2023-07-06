/* TPC-DS query40.tpl 0.86 */
SELECT  w_state
       ,i_item_id
       ,SUM(case WHEN (cast(d_date AS date) < cast ('2001-03-21' AS date)) THEN cs_sales_price - coalesce(cr_refunded_cash,0) else 0 end)  AS sales_before
       ,SUM(case WHEN (cast(d_date AS date) >= cast ('2001-03-21' AS date)) THEN cs_sales_price - coalesce(cr_refunded_cash,0) else 0 end) AS sales_after
FROM catalog_sales
LEFT OUTER JOIN catalog_returns
ON (cs_order_number = cr_order_number AND cs_item_sk = cr_item_sk) , warehouse , item , date_dim
WHERE i_current_price BETWEEN 0.99 AND 1.49
AND i_item_sk = cs_item_sk
AND cs_warehouse_sk = w_warehouse_sk
AND cs_sold_date_sk = d_date_sk
AND d_date BETWEEN dateadd(day, -30, cast ('2001-03-21' AS date)) AND dateadd(day, 30, cast ('2001-03-21' AS date))
GROUP BY  w_state
         ,i_item_id
ORDER BY w_state
         ,i_item_id;