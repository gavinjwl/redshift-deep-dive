/* TPC-DS query99.tpl 0.94 */
SELECT  substring(w_warehouse_name,1,20)
       ,sm_type
       ,cc_name
       ,SUM(case WHEN (cs_ship_date_sk - cs_sold_date_sk <= 30 ) THEN 1 else 0 end)                                              AS "30 days"
       ,SUM(case WHEN (cs_ship_date_sk - cs_sold_date_sk > 30) AND (cs_ship_date_sk - cs_sold_date_sk <= 60) THEN 1 else 0 end ) AS "31-60 days"
       ,SUM(case WHEN (cs_ship_date_sk - cs_sold_date_sk > 60) AND (cs_ship_date_sk - cs_sold_date_sk <= 90) THEN 1 else 0 end)  AS "61-90 days"
       ,SUM(case WHEN (cs_ship_date_sk - cs_sold_date_sk > 90) AND (cs_ship_date_sk - cs_sold_date_sk <= 120) THEN 1 else 0 end) AS "91-120 days"
       ,SUM(case WHEN (cs_ship_date_sk - cs_sold_date_sk > 120) THEN 1 else 0 end)                                               AS ">120 days"
FROM catalog_sales , warehouse , ship_mode , call_center , date_dim
WHERE d_month_seq BETWEEN 1206 AND 1206 + 11
AND cs_ship_date_sk = d_date_sk
AND cs_warehouse_sk = w_warehouse_sk
AND cs_ship_mode_sk = sm_ship_mode_sk
AND cs_call_center_sk = cc_call_center_sk
GROUP BY  substring(w_warehouse_name,1,20)
         ,sm_type
         ,cc_name
ORDER BY substring(w_warehouse_name,1,20)
         ,sm_type
         ,cc_name;