/* TPC-DS query98.tpl 0.32 */
SELECT  i_item_id
       ,i_item_desc
       ,i_category
       ,i_class
       ,i_current_price
       ,SUM(ss_ext_sales_price)                                                              AS itemrevenue
       ,SUM(ss_ext_sales_price)*100/SUM(SUM(ss_ext_sales_price)) over (partition by i_class) AS revenueratio
FROM store_sales , item , date_dim
WHERE ss_item_sk = i_item_sk
AND i_category IN ('Men', 'Music', 'Shoes')
AND ss_sold_date_sk = d_date_sk
AND d_date BETWEEN cast('2001-03-17' AS date) AND dateadd(day, 30, cast('2001-03-17' AS date))
GROUP BY  i_item_id
         ,i_item_desc
         ,i_category
         ,i_class
         ,i_current_price
ORDER BY i_category
         ,i_class
         ,i_item_id
         ,i_item_desc
         ,revenueratio;