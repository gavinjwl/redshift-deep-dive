/* TPC-DS query89.tpl 0.56 */
SELECT  *
FROM
(
	SELECT  i_category
	       ,i_class
	       ,i_brand
	       ,s_store_name
	       ,s_company_name
	       ,d_moy
	       ,SUM(ss_sales_price) sum_sales
	       ,AVG(SUM(ss_sales_price)) over (partition by i_category,i_brand,s_store_name,s_company_name) avg_monthly_sales
	FROM item, store_sales, date_dim, store
	WHERE ss_item_sk = i_item_sk
	AND ss_sold_date_sk = d_date_sk
	AND ss_store_sk = s_store_sk
	AND d_year IN (1999)
	AND ((i_category IN ('Shoes', 'Men', 'Music') AND i_class IN ('kids', 'sports-apparel', 'classical') ) or (i_category IN ('Electronics', 'Women', 'Jewelry') AND i_class IN ('portable', 'fragrances', 'diamonds') ))
	GROUP BY  i_category
	         ,i_class
	         ,i_brand
	         ,s_store_name
	         ,s_company_name
	         ,d_moy
) tmp1
WHERE CASE WHEN (avg_monthly_sales <> 0) THEN (abs(sum_sales - avg_monthly_sales) / avg_monthly_sales) else null end > 0.1
ORDER BY sum_sales - avg_monthly_sales, s_store_name;