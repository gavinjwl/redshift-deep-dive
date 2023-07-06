/* TPC-DS query59.tpl 0.30 */
WITH wss AS
(
	SELECT  d_week_seq
	       ,ss_store_sk
	       ,SUM(case WHEN (d_day_name = 'Sunday') THEN ss_sales_price else null end) sun_sales
	       ,SUM(case WHEN (d_day_name = 'Monday') THEN ss_sales_price else null end) mon_sales
	       ,SUM(case WHEN (d_day_name = 'Tuesday') THEN ss_sales_price else null end) tue_sales
	       ,SUM(case WHEN (d_day_name = 'Wednesday') THEN ss_sales_price else null end) wed_sales
	       ,SUM(case WHEN (d_day_name = 'Thursday') THEN ss_sales_price else null end) thu_sales
	       ,SUM(case WHEN (d_day_name = 'Friday') THEN ss_sales_price else null end) fri_sales
	       ,SUM(case WHEN (d_day_name = 'Saturday') THEN ss_sales_price else null end) sat_sales
	FROM store_sales, date_dim
	WHERE d_date_sk = ss_sold_date_sk
	GROUP BY  d_week_seq
	         ,ss_store_sk
)
SELECT  s_store_name1
       ,s_store_id1
       ,d_week_seq1
       ,sun_sales1/sun_sales2
       ,mon_sales1/mon_sales2
       ,tue_sales1/tue_sales2
       ,wed_sales1/wed_sales2
       ,thu_sales1/thu_sales2
       ,fri_sales1/fri_sales2
       ,sat_sales1/sat_sales2
FROM
(
	SELECT  s_store_name s_store_name1
	       ,wss.d_week_seq d_week_seq1
	       ,s_store_id s_store_id1
	       ,sun_sales sun_sales1
	       ,mon_sales mon_sales1
	       ,tue_sales tue_sales1
	       ,wed_sales wed_sales1
	       ,thu_sales thu_sales1
	       ,fri_sales fri_sales1
	       ,sat_sales sat_sales1
	FROM wss, store, date_dim d
	WHERE d.d_week_seq = wss.d_week_seq
	AND ss_store_sk = s_store_sk
	AND d_month_seq BETWEEN 1182 AND 1182 + 11
) y, (
SELECT  s_store_name s_store_name2
       ,wss.d_week_seq d_week_seq2
       ,s_store_id s_store_id2
       ,sun_sales sun_sales2
       ,mon_sales mon_sales2
       ,tue_sales tue_sales2
       ,wed_sales wed_sales2
       ,thu_sales thu_sales2
       ,fri_sales fri_sales2
       ,sat_sales sat_sales2
FROM wss, store, date_dim d
WHERE d.d_week_seq = wss.d_week_seq
AND ss_store_sk = s_store_sk
AND d_month_seq BETWEEN 1182+ 12 AND 1182 + 23) x
WHERE s_store_id1 = s_store_id2
AND d_week_seq1 = d_week_seq2-52
ORDER BY s_store_name1, s_store_id1, d_week_seq1;