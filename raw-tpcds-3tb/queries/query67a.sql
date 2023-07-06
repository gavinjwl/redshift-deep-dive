/* TPC-DS query67a.tpl 0.35 */
WITH results AS
(
	SELECT  i_category
	       ,i_class
	       ,i_brand
	       ,i_product_name
	       ,d_year
	       ,d_qoy
	       ,d_moy
	       ,s_store_id
	       ,SUM(coalesce(ss_sales_price*ss_quantity,0)) sumsales
	FROM store_sales , date_dim , store , item
	WHERE ss_sold_date_sk = d_date_sk
	AND ss_item_sk = i_item_sk
	AND ss_store_sk = s_store_sk
	AND d_month_seq BETWEEN 1219 AND 1219 + 11
	GROUP BY  i_category
	         ,i_class
	         ,i_brand
	         ,i_product_name
	         ,d_year
	         ,d_qoy
	         ,d_moy
	         ,s_store_id
) , results_rollup AS
(
	SELECT  i_category
	       ,i_class
	       ,i_brand
	       ,i_product_name
	       ,d_year
	       ,d_qoy
	       ,d_moy
	       ,s_store_id
	       ,sumsales
	FROM results
	UNION ALL
	SELECT  i_category
	       ,i_class
	       ,i_brand
	       ,i_product_name
	       ,d_year
	       ,d_qoy
	       ,d_moy
	       ,null s_store_id
	       ,SUM(sumsales) sumsales
	FROM results
	GROUP BY  i_category
	         ,i_class
	         ,i_brand
	         ,i_product_name
	         ,d_year
	         ,d_qoy
	         ,d_moy
	UNION ALL
	SELECT  i_category
	       ,i_class
	       ,i_brand
	       ,i_product_name
	       ,d_year
	       ,d_qoy
	       ,null d_moy
	       ,null s_store_id
	       ,SUM(sumsales) sumsales
	FROM results
	GROUP BY  i_category
	         ,i_class
	         ,i_brand
	         ,i_product_name
	         ,d_year
	         ,d_qoy
	UNION ALL
	SELECT  i_category
	       ,i_class
	       ,i_brand
	       ,i_product_name
	       ,d_year
	       ,null d_qoy
	       ,null d_moy
	       ,null s_store_id
	       ,SUM(sumsales) sumsales
	FROM results
	GROUP BY  i_category
	         ,i_class
	         ,i_brand
	         ,i_product_name
	         ,d_year
	UNION ALL
	SELECT  i_category
	       ,i_class
	       ,i_brand
	       ,i_product_name
	       ,null d_year
	       ,null d_qoy
	       ,null d_moy
	       ,null s_store_id
	       ,SUM(sumsales) sumsales
	FROM results
	GROUP BY  i_category
	         ,i_class
	         ,i_brand
	         ,i_product_name
	UNION ALL
	SELECT  i_category
	       ,i_class
	       ,i_brand
	       ,null i_product_name
	       ,null d_year
	       ,null d_qoy
	       ,null d_moy
	       ,null s_store_id
	       ,SUM(sumsales) sumsales
	FROM results
	GROUP BY  i_category
	         ,i_class
	         ,i_brand
	UNION ALL
	SELECT  i_category
	       ,i_class
	       ,null i_brand
	       ,null i_product_name
	       ,null d_year
	       ,null d_qoy
	       ,null d_moy
	       ,null s_store_id
	       ,SUM(sumsales) sumsales
	FROM results
	GROUP BY  i_category
	         ,i_class
	UNION ALL
	SELECT  i_category
	       ,null i_class
	       ,null i_brand
	       ,null i_product_name
	       ,null d_year
	       ,null d_qoy
	       ,null d_moy
	       ,null s_store_id
	       ,SUM(sumsales) sumsales
	FROM results
	GROUP BY  i_category
	UNION ALL
	SELECT  null i_category
	       ,null i_class
	       ,null i_brand
	       ,null i_product_name
	       ,null d_year
	       ,null d_qoy
	       ,null d_moy
	       ,null s_store_id
	       ,SUM(sumsales) sumsales
	FROM results
)
SELECT  *
FROM
(
	SELECT  i_category
	       ,i_class
	       ,i_brand
	       ,i_product_name
	       ,d_year
	       ,d_qoy
	       ,d_moy
	       ,s_store_id
	       ,sumsales
	       ,rank() over (partition by i_category ORDER BY sumsales desc) rk
	FROM results_rollup
) dw2
WHERE rk <= 100
ORDER BY i_category , i_class , i_brand , i_product_name , d_year , d_qoy , d_moy , s_store_id , sumsales , rk;