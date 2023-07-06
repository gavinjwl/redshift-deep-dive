/* TPC-DS query20.tpl 0.65 */
SELECT  i_item_id
       ,i_item_desc
       ,i_category
       ,i_class
       ,i_current_price
       ,SUM(cs_ext_sales_price)                                                              AS itemrevenue
       ,SUM(cs_ext_sales_price)*100/SUM(SUM(cs_ext_sales_price)) over (partition by i_class) AS revenueratio
FROM catalog_sales , item , date_dim
WHERE cs_item_sk = i_item_sk
AND i_category IN ('Shoes', 'Sports', 'Electronics')
AND cs_sold_date_sk = d_date_sk
AND d_date BETWEEN cast('1998-05-13' AS date) AND dateadd(day, 30, cast('1998-05-13' AS date))
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