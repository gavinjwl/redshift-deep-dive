/* TPC-DS query97.tpl 0.38 */
WITH ssci AS
(
	SELECT  ss_customer_sk customer_sk
	       ,ss_item_sk item_sk
	FROM store_sales, date_dim
	WHERE ss_sold_date_sk = d_date_sk
	AND d_month_seq BETWEEN 1180 AND 1180 + 11
	GROUP BY  ss_customer_sk
	         ,ss_item_sk
), csci as(
SELECT  cs_bill_customer_sk customer_sk
       ,cs_item_sk item_sk
FROM catalog_sales, date_dim
WHERE cs_sold_date_sk = d_date_sk
AND d_month_seq BETWEEN 1180 AND 1180 + 11
GROUP BY  cs_bill_customer_sk
         ,cs_item_sk)
SELECT  SUM(case WHEN ssci.customer_sk is not null AND csci.customer_sk is null THEN 1 else 0 end) store_only
       ,SUM(case WHEN ssci.customer_sk is null AND csci.customer_sk is not null THEN 1 else 0 end) catalog_only
       ,SUM(case WHEN ssci.customer_sk is not null AND csci.customer_sk is not null THEN 1 else 0 end) store_and_catalog
FROM ssci
FULL OUTER JOIN csci
ON (ssci.customer_sk = csci.customer_sk AND ssci.item_sk = csci.item_sk);