/* TPC-DS query80a.tpl 0.6 */
WITH ssr AS
(
	SELECT  s_store_id                                   AS store_id
	       ,SUM(ss_ext_sales_price)                      AS sales
	       ,SUM(coalesce(sr_return_amt,0))               AS returns
	       ,SUM(ss_net_profit - coalesce(sr_net_loss,0)) AS profit
	FROM store_sales
	LEFT OUTER JOIN store_returns
	ON (ss_item_sk = sr_item_sk AND ss_ticket_number = sr_ticket_number), date_dim, store, item, promotion
	WHERE ss_sold_date_sk = d_date_sk
	AND d_date BETWEEN cast('2002-08-04' AS date) AND dateadd(day, 30, cast('2002-08-04' AS date))
	AND ss_store_sk = s_store_sk
	AND ss_item_sk = i_item_sk
	AND i_current_price > 50
	AND ss_promo_sk = p_promo_sk
	AND p_channel_tv = 'N'
	GROUP BY  s_store_id
), csr AS
(
	SELECT  cp_catalog_page_id                           AS catalog_page_id
	       ,SUM(cs_ext_sales_price)                      AS sales
	       ,SUM(coalesce(cr_return_amount,0))            AS returns
	       ,SUM(cs_net_profit - coalesce(cr_net_loss,0)) AS profit
	FROM catalog_sales
	LEFT OUTER JOIN catalog_returns
	ON (cs_item_sk = cr_item_sk AND cs_order_number = cr_order_number), date_dim, catalog_page, item, promotion
	WHERE cs_sold_date_sk = d_date_sk
	AND d_date BETWEEN cast('2002-08-04' AS date) AND dateadd(day, 30, cast('2002-08-04' AS date))
	AND cs_catalog_page_sk = cp_catalog_page_sk
	AND cs_item_sk = i_item_sk
	AND i_current_price > 50
	AND cs_promo_sk = p_promo_sk
	AND p_channel_tv = 'N'
	GROUP BY  cp_catalog_page_id
), wsr AS
(
	SELECT  web_site_id
	       ,SUM(ws_ext_sales_price)                      AS sales
	       ,SUM(coalesce(wr_return_amt,0))               AS returns
	       ,SUM(ws_net_profit - coalesce(wr_net_loss,0)) AS profit
	FROM web_sales
	LEFT OUTER JOIN web_returns
	ON (ws_item_sk = wr_item_sk AND ws_order_number = wr_order_number), date_dim, web_site, item, promotion
	WHERE ws_sold_date_sk = d_date_sk
	AND d_date BETWEEN cast('2002-08-04' AS date) AND dateadd(day, 30, cast('2002-08-04' AS date))
	AND ws_web_site_sk = web_site_sk
	AND ws_item_sk = i_item_sk
	AND i_current_price > 50
	AND ws_promo_sk = p_promo_sk
	AND p_channel_tv = 'N'
	GROUP BY  web_site_id
), results AS
(
	SELECT  channel
	       ,id
	       ,SUM(sales)   AS sales
	       ,SUM(returns) AS returns
	       ,SUM(profit)  AS profit
	FROM
	(
		SELECT  'store channel'     AS channel
		       ,'store' || store_id AS id
		       ,sales
		       ,returns
		       ,profit
		FROM ssr
		UNION ALL
		SELECT  'catalog channel'                 AS channel
		       ,'catalog_page' || catalog_page_id AS id
		       ,sales
		       ,returns
		       ,profit
		FROM csr
		UNION ALL
		SELECT  'web channel'             AS channel
		       ,'web_site' || web_site_id AS id
		       ,sales
		       ,returns
		       ,profit
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
	       ,NULL         AS id
	       ,SUM(sales)   AS sales
	       ,SUM(returns) AS returns
	       ,SUM(profit)  AS profit
	FROM results
	GROUP BY  channel
	UNION
	SELECT  NULL         AS channel
	       ,NULL         AS id
	       ,SUM(sales)   AS sales
	       ,SUM(returns) AS returns
	       ,SUM(profit)  AS profit
	FROM results
) foo
ORDER BY channel, id;