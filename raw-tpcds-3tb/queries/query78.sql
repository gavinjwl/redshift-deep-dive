/* TPC-DS query78.tpl 0.10 */
WITH ws AS
(
	SELECT  d_year AS ws_sold_year
	       ,ws_item_sk
	       ,ws_bill_customer_sk ws_customer_sk
	       ,SUM(ws_quantity) ws_qty
	       ,SUM(ws_wholesale_cost) ws_wc
	       ,SUM(ws_sales_price) ws_sp
	FROM web_sales
	LEFT JOIN web_returns
	ON wr_order_number = ws_order_number AND ws_item_sk = wr_item_sk
	JOIN date_dim
	ON ws_sold_date_sk = d_date_sk
	WHERE wr_order_number is null
	GROUP BY  d_year
	         ,ws_item_sk
	         ,ws_bill_customer_sk
), cs AS
(
	SELECT  d_year AS cs_sold_year
	       ,cs_item_sk
	       ,cs_bill_customer_sk cs_customer_sk
	       ,SUM(cs_quantity) cs_qty
	       ,SUM(cs_wholesale_cost) cs_wc
	       ,SUM(cs_sales_price) cs_sp
	FROM catalog_sales
	LEFT JOIN catalog_returns
	ON cr_order_number = cs_order_number AND cs_item_sk = cr_item_sk
	JOIN date_dim
	ON cs_sold_date_sk = d_date_sk
	WHERE cr_order_number is null
	GROUP BY  d_year
	         ,cs_item_sk
	         ,cs_bill_customer_sk
), ss AS
(
	SELECT  d_year AS ss_sold_year
	       ,ss_item_sk
	       ,ss_customer_sk
	       ,SUM(ss_quantity) ss_qty
	       ,SUM(ss_wholesale_cost) ss_wc
	       ,SUM(ss_sales_price) ss_sp
	FROM store_sales
	LEFT JOIN store_returns
	ON sr_ticket_number = ss_ticket_number AND ss_item_sk = sr_item_sk
	JOIN date_dim
	ON ss_sold_date_sk = d_date_sk
	WHERE sr_ticket_number is null
	GROUP BY  d_year
	         ,ss_item_sk
	         ,ss_customer_sk
)
SELECT  ss_customer_sk
       ,round(ss_qty/(coalesce(ws_qty,0)+coalesce(cs_qty,0)),2) ratio
       ,ss_qty store_qty
       ,ss_wc store_wholesale_cost
       ,ss_sp store_sales_price
       ,coalesce(ws_qty,0)+coalesce(cs_qty,0) other_chan_qty
       ,coalesce(ws_wc,0)+coalesce(cs_wc,0) other_chan_wholesale_cost
       ,coalesce(ws_sp,0)+coalesce(cs_sp,0) other_chan_sales_price
FROM ss
LEFT JOIN ws
ON (ws_sold_year = ss_sold_year AND ws_item_sk = ss_item_sk AND ws_customer_sk = ss_customer_sk)
LEFT JOIN cs
ON (cs_sold_year = ss_sold_year AND cs_item_sk = ss_item_sk AND cs_customer_sk = ss_customer_sk)
WHERE (coalesce(ws_qty, 0) > 0 or coalesce(cs_qty, 0) > 0)
AND ss_sold_year = 2001
ORDER BY ss_customer_sk, ss_qty desc, ss_wc desc, ss_sp desc, other_chan_qty, other_chan_wholesale_cost, other_chan_sales_price, ratio;