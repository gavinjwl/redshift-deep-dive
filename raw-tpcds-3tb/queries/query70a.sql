/* TPC-DS query70a.tpl 0.34 */
WITH results AS
(
	SELECT  SUM(ss_net_profit) AS total_sum
	       ,s_state
	       ,s_county
	       ,0                  AS gstate
	       ,0                  AS g_county
	FROM store_sales , date_dim d1 , store
	WHERE d1.d_month_seq BETWEEN 1188 AND 1188 + 11
	AND d1.d_date_sk = ss_sold_date_sk
	AND s_store_sk = ss_store_sk
	AND s_state IN ( SELECT s_state FROM  ( SELECT s_state AS s_state, rank() over ( partition by s_state ORDER BY SUM(ss_net_profit) desc) AS ranking FROM store_sales, store, date_dim WHERE d_month_seq BETWEEN 1188 AND 1188 + 11 AND d_date_sk = ss_sold_date_sk AND s_store_sk = ss_store_sk GROUP BY s_state  ) tmp1 WHERE ranking <= 5)
	GROUP BY  s_state
	         ,s_county
) , results_rollup AS
(
	SELECT  total_sum
	       ,s_state
	       ,s_county
	       ,0 AS g_state
	       ,0 AS g_county
	       ,0 AS lochierarchy
	FROM results
	UNION
	SELECT  SUM(total_sum) AS total_sum
	       ,s_state
	       ,NULL           AS s_county
	       ,0              AS g_state
	       ,1              AS g_county
	       ,1              AS lochierarchy
	FROM results
	GROUP BY  s_state
	UNION
	SELECT  SUM(total_sum) AS total_sum
	       ,NULL           AS s_state
	       ,NULL           AS s_county
	       ,1              AS g_state
	       ,1              AS g_county
	       ,2              AS lochierarchy
	FROM results
)
SELECT  total_sum
       ,s_state
       ,s_county
       ,lochierarchy
       ,rank() over ( partition by lochierarchy,CASE WHEN g_county = 0 THEN s_state end ORDER BY total_sum desc) AS rank_within_parent
FROM results_rollup
ORDER BY lochierarchy desc , CASE WHEN lochierarchy = 0 THEN s_state end , rank_within_parent;