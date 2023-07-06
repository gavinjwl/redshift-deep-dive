/* TPC-DS query63.tpl 0.27 */
SELECT  *
FROM
(
	SELECT  i_manager_id
	       ,SUM(ss_sales_price) sum_sales
	       ,AVG(SUM(ss_sales_price)) over (partition by i_manager_id) avg_monthly_sales
	FROM item , store_sales , date_dim , store
	WHERE ss_item_sk = i_item_sk
	AND ss_sold_date_sk = d_date_sk
	AND ss_store_sk = s_store_sk
	AND d_month_seq IN (1223, 1223+1, 1223+2, 1223+3, 1223+4, 1223+5, 1223+6, 1223+7, 1223+8, 1223+9, 1223+10, 1223+11)
	AND (( i_category IN ('Books', 'Children', 'Electronics') AND i_class IN ('personal', 'portable', 'reference', 'self-help') AND i_brand IN ('scholaramalgamalg #14', 'scholaramalgamalg #7', 'exportiunivamalg #9', 'scholaramalgamalg #9')) or( i_category IN ('Women', 'Music', 'Men') AND i_class IN ('accessories', 'classical', 'fragrances', 'pants') AND i_brand IN ('amalgimporto #1', 'edu packscholar #1', 'exportiimporto #1', 'importoamalg #1')))
	GROUP BY  i_manager_id
	         ,d_moy
) tmp1
WHERE CASE WHEN avg_monthly_sales > 0 THEN abs (sum_sales - avg_monthly_sales) / avg_monthly_sales else null end > 0.1
ORDER BY i_manager_id , avg_monthly_sales , sum_sales;