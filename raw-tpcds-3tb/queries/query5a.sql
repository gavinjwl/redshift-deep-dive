/* TPC-DS query5a.tpl 0.98 */
WITH ssr AS
(
	SELECT  s_store_id
	       ,SUM(sales_price) AS sales
	       ,SUM(profit)      AS profit
	       ,SUM(return_amt)  AS returns
	       ,SUM(net_loss)    AS profit_loss
	FROM
	(
		SELECT  ss_store_sk             AS store_sk
		       ,ss_sold_date_sk         AS date_sk
		       ,ss_ext_sales_price      AS sales_price
		       ,ss_net_profit           AS profit
		       ,cast(0 AS decimal(7,2)) AS return_amt
		       ,cast(0 AS decimal(7,2)) AS net_loss
		FROM store_sales
		UNION ALL
		SELECT  sr_store_sk             AS store_sk
		       ,sr_returned_date_sk     AS date_sk
		       ,cast(0 AS decimal(7,2)) AS sales_price
		       ,cast(0 AS decimal(7,2)) AS profit
		       ,sr_return_amt           AS return_amt
		       ,sr_net_loss             AS net_loss
		FROM store_returns
	) salesreturns, date_dim, store
	WHERE date_sk = d_date_sk
	AND d_date BETWEEN cast('1998-08-11' AS date) AND dateadd(day, 14, cast('1998-08-11' AS date))
	AND store_sk = s_store_sk
	GROUP BY  s_store_id
) , csr AS
(
	SELECT  cp_catalog_page_id
	       ,SUM(sales_price) AS sales
	       ,SUM(profit)      AS profit
	       ,SUM(return_amt)  AS returns
	       ,SUM(net_loss)    AS profit_loss
	FROM
	(
		SELECT  cs_catalog_page_sk      AS page_sk
		       ,cs_sold_date_sk         AS date_sk
		       ,cs_ext_sales_price      AS sales_price
		       ,cs_net_profit           AS profit
		       ,cast(0 AS decimal(7,2)) AS return_amt
		       ,cast(0 AS decimal(7,2)) AS net_loss
		FROM catalog_sales
		UNION ALL
		SELECT  cr_catalog_page_sk      AS page_sk
		       ,cr_returned_date_sk     AS date_sk
		       ,cast(0 AS decimal(7,2)) AS sales_price
		       ,cast(0 AS decimal(7,2)) AS profit
		       ,cr_return_amount        AS return_amt
		       ,cr_net_loss             AS net_loss
		FROM catalog_returns
	) salesreturns, date_dim, catalog_page
	WHERE date_sk = d_date_sk
	AND d_date BETWEEN cast('1998-08-11' AS date) AND dateadd(day, 14, cast('1998-08-11' AS date))
	AND page_sk = cp_catalog_page_sk
	GROUP BY  cp_catalog_page_id
) , wsr AS
(
	SELECT  web_site_id
	       ,SUM(sales_price) AS sales
	       ,SUM(profit)      AS profit
	       ,SUM(return_amt)  AS returns
	       ,SUM(net_loss)    AS profit_loss
	FROM
	(
		SELECT  ws_web_site_sk          AS wsr_web_site_sk
		       ,ws_sold_date_sk         AS date_sk
		       ,ws_ext_sales_price      AS sales_price
		       ,ws_net_profit           AS profit
		       ,cast(0 AS decimal(7,2)) AS return_amt
		       ,cast(0 AS decimal(7,2)) AS net_loss
		FROM web_sales
		UNION ALL
		SELECT  ws_web_site_sk          AS wsr_web_site_sk
		       ,wr_returned_date_sk     AS date_sk
		       ,cast(0 AS decimal(7,2)) AS sales_price
		       ,cast(0 AS decimal(7,2)) AS profit
		       ,wr_return_amt           AS return_amt
		       ,wr_net_loss             AS net_loss
		FROM web_returns
		LEFT OUTER JOIN web_sales
		ON ( wr_item_sk = ws_item_sk AND wr_order_number = ws_order_number)
	) salesreturns, date_dim, web_site
	WHERE date_sk = d_date_sk
	AND d_date BETWEEN cast('1998-08-11' AS date) AND dateadd(day, 14, cast('1998-08-11' AS date))
	AND wsr_web_site_sk = web_site_sk
	GROUP BY  web_site_id
) , results AS
(
	SELECT  channel
	       ,id
	       ,SUM(sales)   AS sales
	       ,SUM(returns) AS returns
	       ,SUM(profit)  AS profit
	FROM
	(
		SELECT  'store channel'        AS channel
		       ,'store' || s_store_id  AS id
		       ,sales
		       ,returns
		       ,(profit - profit_loss) AS profit
		FROM ssr
		UNION ALL
		SELECT  'catalog channel'                    AS channel
		       ,'catalog_page' || cp_catalog_page_id AS id
		       ,sales
		       ,returns
		       ,(profit - profit_loss)               AS profit
		FROM csr
		UNION ALL
		SELECT  'web channel'             AS channel
		       ,'web_site' || web_site_id AS id
		       ,sales
		       ,returns
		       ,(profit - profit_loss)    AS profit
		FROM wsr
	) x
	GROUP BY  channel
	         ,id
)
SELECT  channel
       ,id
       ,sales
       ,returns
       ,profit
FROM
(
	SELECT  channel
	       ,id
	       ,sales
	       ,returns
	       ,profit
	FROM results
	UNION
	SELECT  channel
	       ,null AS id
	       ,SUM(sales)
	       ,SUM(returns)
	       ,SUM(profit)
	FROM results
	GROUP BY  channel
	UNION
	SELECT  null AS channel
	       ,null AS id
	       ,SUM(sales)
	       ,SUM(returns)
	       ,SUM(profit)
	FROM results
) foo
ORDER BY channel, id;