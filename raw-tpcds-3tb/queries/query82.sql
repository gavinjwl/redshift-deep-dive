/* TPC-DS query82.tpl 0.67 */
SELECT  i_item_id
       ,i_item_desc
       ,i_current_price
FROM item, inventory, date_dim, store_sales
WHERE i_current_price BETWEEN 12 AND 12+30
AND inv_item_sk = i_item_sk
AND d_date_sk = inv_date_sk
AND d_date BETWEEN cast('2002-04-05' AS date) AND dateadd(day, 60, cast('2002-04-05' AS date))
AND i_manufact_id IN (400, 448, 910, 149)
AND inv_quantity_on_hand BETWEEN 100 AND 500
AND ss_item_sk = i_item_sk
GROUP BY  i_item_id
         ,i_item_desc
         ,i_current_price
ORDER BY i_item_id;