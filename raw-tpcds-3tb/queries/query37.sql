/* TPC-DS query37.tpl 0.31 */
SELECT  i_item_id
       ,i_item_desc
       ,i_current_price
FROM item, inventory, date_dim, catalog_sales
WHERE i_current_price BETWEEN 24 AND 24 + 30
AND inv_item_sk = i_item_sk
AND d_date_sk = inv_date_sk
AND d_date BETWEEN cast('2002-06-22' AS date) AND dateadd(day, 60, cast('2002-06-22' AS date))
AND i_manufact_id IN (951, 717, 692, 953)
AND inv_quantity_on_hand BETWEEN 100 AND 500
AND cs_item_sk = i_item_sk
GROUP BY  i_item_id
         ,i_item_desc
         ,i_current_price
ORDER BY i_item_id;