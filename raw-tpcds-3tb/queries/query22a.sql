/* TPC-DS query22a.tpl 0.55 */
WITH results AS
(
	SELECT  i_product_name
	       ,i_brand
	       ,i_class
	       ,i_category
	       ,AVG(inv_quantity_on_hand) qoh
	FROM inventory , date_dim , item
	-- , warehouse
	WHERE inv_date_sk = d_date_sk
	AND inv_item_sk = i_item_sk
	--
	AND inv_warehouse_sk = w_warehouse_sk
	AND d_month_seq BETWEEN 1183 AND 1183 + 11
	GROUP BY  i_product_name
	         ,i_brand
	         ,i_class
	         ,i_category
), results_rollup AS
(
	SELECT  i_product_name
	       ,i_brand
	       ,i_class
	       ,i_category
	       ,AVG(qoh) qoh
	FROM results
	GROUP BY  i_product_name
	         ,i_brand
	         ,i_class
	         ,i_category
	UNION ALL
	SELECT  i_product_name
	       ,i_brand
	       ,i_class
	       ,null i_category
	       ,AVG(qoh) qoh
	FROM results
	GROUP BY  i_product_name
	         ,i_brand
	         ,i_class
	UNION ALL
	SELECT  i_product_name
	       ,i_brand
	       ,null i_class
	       ,null i_category
	       ,AVG(qoh) qoh
	FROM results
	GROUP BY  i_product_name
	         ,i_brand
	UNION ALL
	SELECT  i_product_name
	       ,null i_brand
	       ,null i_class
	       ,null i_category
	       ,AVG(qoh) qoh
	FROM results
	GROUP BY  i_product_name
	UNION ALL
	SELECT  null i_product_name
	       ,null i_brand
	       ,null i_class
	       ,null i_category
	       ,AVG(qoh) qoh
	FROM results
)
SELECT  i_product_name
       ,i_brand
       ,i_class
       ,i_category
       ,qoh
FROM results_rollup
ORDER BY qoh, i_product_name, i_brand, i_class, i_category;