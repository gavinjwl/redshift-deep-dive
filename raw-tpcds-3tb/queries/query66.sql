/* TPC-DS query66.tpl 0.39 */
SELECT  w_warehouse_name
       ,w_warehouse_sq_ft
       ,w_city
       ,w_county
       ,w_state
       ,w_country
       ,ship_carriers
       ,year
       ,SUM(jan_sales)                   AS jan_sales
       ,SUM(feb_sales)                   AS feb_sales
       ,SUM(mar_sales)                   AS mar_sales
       ,SUM(apr_sales)                   AS apr_sales
       ,SUM(may_sales)                   AS may_sales
       ,SUM(jun_sales)                   AS jun_sales
       ,SUM(jul_sales)                   AS jul_sales
       ,SUM(aug_sales)                   AS aug_sales
       ,SUM(sep_sales)                   AS sep_sales
       ,SUM(oct_sales)                   AS oct_sales
       ,SUM(nov_sales)                   AS nov_sales
       ,SUM(dec_sales)                   AS dec_sales
       ,SUM(jan_sales/w_warehouse_sq_ft) AS jan_sales_per_sq_foot
       ,SUM(feb_sales/w_warehouse_sq_ft) AS feb_sales_per_sq_foot
       ,SUM(mar_sales/w_warehouse_sq_ft) AS mar_sales_per_sq_foot
       ,SUM(apr_sales/w_warehouse_sq_ft) AS apr_sales_per_sq_foot
       ,SUM(may_sales/w_warehouse_sq_ft) AS may_sales_per_sq_foot
       ,SUM(jun_sales/w_warehouse_sq_ft) AS jun_sales_per_sq_foot
       ,SUM(jul_sales/w_warehouse_sq_ft) AS jul_sales_per_sq_foot
       ,SUM(aug_sales/w_warehouse_sq_ft) AS aug_sales_per_sq_foot
       ,SUM(sep_sales/w_warehouse_sq_ft) AS sep_sales_per_sq_foot
       ,SUM(oct_sales/w_warehouse_sq_ft) AS oct_sales_per_sq_foot
       ,SUM(nov_sales/w_warehouse_sq_ft) AS nov_sales_per_sq_foot
       ,SUM(dec_sales/w_warehouse_sq_ft) AS dec_sales_per_sq_foot
       ,SUM(jan_net)                     AS jan_net
       ,SUM(feb_net)                     AS feb_net
       ,SUM(mar_net)                     AS mar_net
       ,SUM(apr_net)                     AS apr_net
       ,SUM(may_net)                     AS may_net
       ,SUM(jun_net)                     AS jun_net
       ,SUM(jul_net)                     AS jul_net
       ,SUM(aug_net)                     AS aug_net
       ,SUM(sep_net)                     AS sep_net
       ,SUM(oct_net)                     AS oct_net
       ,SUM(nov_net)                     AS nov_net
       ,SUM(dec_net)                     AS dec_net
FROM
(
	SELECT  w_warehouse_name
	       ,w_warehouse_sq_ft
	       ,w_city
	       ,w_county
	       ,w_state
	       ,w_country
	       ,'BARIAN' || ',' || 'FEDEX'                                                   AS ship_carriers
	       ,d_year                                                                       AS year
	       ,SUM(case WHEN d_moy = 1 THEN ws_ext_sales_price* ws_quantity else 0 end)     AS jan_sales
	       ,SUM(case WHEN d_moy = 2 THEN ws_ext_sales_price* ws_quantity else 0 end)     AS feb_sales
	       ,SUM(case WHEN d_moy = 3 THEN ws_ext_sales_price* ws_quantity else 0 end)     AS mar_sales
	       ,SUM(case WHEN d_moy = 4 THEN ws_ext_sales_price* ws_quantity else 0 end)     AS apr_sales
	       ,SUM(case WHEN d_moy = 5 THEN ws_ext_sales_price* ws_quantity else 0 end)     AS may_sales
	       ,SUM(case WHEN d_moy = 6 THEN ws_ext_sales_price* ws_quantity else 0 end)     AS jun_sales
	       ,SUM(case WHEN d_moy = 7 THEN ws_ext_sales_price* ws_quantity else 0 end)     AS jul_sales
	       ,SUM(case WHEN d_moy = 8 THEN ws_ext_sales_price* ws_quantity else 0 end)     AS aug_sales
	       ,SUM(case WHEN d_moy = 9 THEN ws_ext_sales_price* ws_quantity else 0 end)     AS sep_sales
	       ,SUM(case WHEN d_moy = 10 THEN ws_ext_sales_price* ws_quantity else 0 end)    AS oct_sales
	       ,SUM(case WHEN d_moy = 11 THEN ws_ext_sales_price* ws_quantity else 0 end)    AS nov_sales
	       ,SUM(case WHEN d_moy = 12 THEN ws_ext_sales_price* ws_quantity else 0 end)    AS dec_sales
	       ,SUM(case WHEN d_moy = 1 THEN ws_net_paid_inc_ship * ws_quantity else 0 end)  AS jan_net
	       ,SUM(case WHEN d_moy = 2 THEN ws_net_paid_inc_ship * ws_quantity else 0 end)  AS feb_net
	       ,SUM(case WHEN d_moy = 3 THEN ws_net_paid_inc_ship * ws_quantity else 0 end)  AS mar_net
	       ,SUM(case WHEN d_moy = 4 THEN ws_net_paid_inc_ship * ws_quantity else 0 end)  AS apr_net
	       ,SUM(case WHEN d_moy = 5 THEN ws_net_paid_inc_ship * ws_quantity else 0 end)  AS may_net
	       ,SUM(case WHEN d_moy = 6 THEN ws_net_paid_inc_ship * ws_quantity else 0 end)  AS jun_net
	       ,SUM(case WHEN d_moy = 7 THEN ws_net_paid_inc_ship * ws_quantity else 0 end)  AS jul_net
	       ,SUM(case WHEN d_moy = 8 THEN ws_net_paid_inc_ship * ws_quantity else 0 end)  AS aug_net
	       ,SUM(case WHEN d_moy = 9 THEN ws_net_paid_inc_ship * ws_quantity else 0 end)  AS sep_net
	       ,SUM(case WHEN d_moy = 10 THEN ws_net_paid_inc_ship * ws_quantity else 0 end) AS oct_net
	       ,SUM(case WHEN d_moy = 11 THEN ws_net_paid_inc_ship * ws_quantity else 0 end) AS nov_net
	       ,SUM(case WHEN d_moy = 12 THEN ws_net_paid_inc_ship * ws_quantity else 0 end) AS dec_net
	FROM web_sales , warehouse , date_dim , time_dim , ship_mode
	WHERE ws_warehouse_sk = w_warehouse_sk
	AND ws_sold_date_sk = d_date_sk
	AND ws_sold_time_sk = t_time_sk
	AND ws_ship_mode_sk = sm_ship_mode_sk
	AND d_year = 2001
	AND t_time BETWEEN 2298 AND 2298+28800
	AND sm_carrier IN ('BARIAN', 'FEDEX')
	GROUP BY  w_warehouse_name
	         ,w_warehouse_sq_ft
	         ,w_city
	         ,w_county
	         ,w_state
	         ,w_country
	         ,d_year
	UNION ALL
	SELECT  w_warehouse_name
	       ,w_warehouse_sq_ft
	       ,w_city
	       ,w_county
	       ,w_state
	       ,w_country
	       ,'BARIAN' || ',' || 'FEDEX'                                                       AS ship_carriers
	       ,d_year                                                                           AS year
	       ,SUM(case WHEN d_moy = 1 THEN cs_ext_sales_price* cs_quantity else 0 end)         AS jan_sales
	       ,SUM(case WHEN d_moy = 2 THEN cs_ext_sales_price* cs_quantity else 0 end)         AS feb_sales
	       ,SUM(case WHEN d_moy = 3 THEN cs_ext_sales_price* cs_quantity else 0 end)         AS mar_sales
	       ,SUM(case WHEN d_moy = 4 THEN cs_ext_sales_price* cs_quantity else 0 end)         AS apr_sales
	       ,SUM(case WHEN d_moy = 5 THEN cs_ext_sales_price* cs_quantity else 0 end)         AS may_sales
	       ,SUM(case WHEN d_moy = 6 THEN cs_ext_sales_price* cs_quantity else 0 end)         AS jun_sales
	       ,SUM(case WHEN d_moy = 7 THEN cs_ext_sales_price* cs_quantity else 0 end)         AS jul_sales
	       ,SUM(case WHEN d_moy = 8 THEN cs_ext_sales_price* cs_quantity else 0 end)         AS aug_sales
	       ,SUM(case WHEN d_moy = 9 THEN cs_ext_sales_price* cs_quantity else 0 end)         AS sep_sales
	       ,SUM(case WHEN d_moy = 10 THEN cs_ext_sales_price* cs_quantity else 0 end)        AS oct_sales
	       ,SUM(case WHEN d_moy = 11 THEN cs_ext_sales_price* cs_quantity else 0 end)        AS nov_sales
	       ,SUM(case WHEN d_moy = 12 THEN cs_ext_sales_price* cs_quantity else 0 end)        AS dec_sales
	       ,SUM(case WHEN d_moy = 1 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end)  AS jan_net
	       ,SUM(case WHEN d_moy = 2 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end)  AS feb_net
	       ,SUM(case WHEN d_moy = 3 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end)  AS mar_net
	       ,SUM(case WHEN d_moy = 4 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end)  AS apr_net
	       ,SUM(case WHEN d_moy = 5 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end)  AS may_net
	       ,SUM(case WHEN d_moy = 6 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end)  AS jun_net
	       ,SUM(case WHEN d_moy = 7 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end)  AS jul_net
	       ,SUM(case WHEN d_moy = 8 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end)  AS aug_net
	       ,SUM(case WHEN d_moy = 9 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end)  AS sep_net
	       ,SUM(case WHEN d_moy = 10 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end) AS oct_net
	       ,SUM(case WHEN d_moy = 11 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end) AS nov_net
	       ,SUM(case WHEN d_moy = 12 THEN cs_net_paid_inc_ship_tax * cs_quantity else 0 end) AS dec_net
	FROM catalog_sales , warehouse , date_dim , time_dim , ship_mode
	WHERE cs_warehouse_sk = w_warehouse_sk
	AND cs_sold_date_sk = d_date_sk
	AND cs_sold_time_sk = t_time_sk
	AND cs_ship_mode_sk = sm_ship_mode_sk
	AND d_year = 2001
	AND t_time BETWEEN 2298 AND 2298+28800
	AND sm_carrier IN ('BARIAN', 'FEDEX')
	GROUP BY  w_warehouse_name
	         ,w_warehouse_sq_ft
	         ,w_city
	         ,w_county
	         ,w_state
	         ,w_country
	         ,d_year
) x
GROUP BY  w_warehouse_name
         ,w_warehouse_sq_ft
         ,w_city
         ,w_county
         ,w_state
         ,w_country
         ,ship_carriers
         ,year
ORDER BY w_warehouse_name;