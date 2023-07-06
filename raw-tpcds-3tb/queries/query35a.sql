/* TPC-DS query35a.tpl 0.47 */
SELECT  ca_state
       ,cd_gender
       ,cd_marital_status
       ,cd_dep_count
       ,COUNT(*) cnt1
       ,MAX(cd_dep_count)
       ,MIN(cd_dep_count)
       ,MAX(cd_dep_count)
       ,cd_dep_employed_count
       ,COUNT(*) cnt2
       ,MAX(cd_dep_employed_count)
       ,MIN(cd_dep_employed_count)
       ,MAX(cd_dep_employed_count)
       ,cd_dep_college_count
       ,COUNT(*) cnt3
       ,MAX(cd_dep_college_count)
       ,MIN(cd_dep_college_count)
       ,MAX(cd_dep_college_count)
FROM customer c, customer_address ca, customer_demographics
WHERE c.c_current_addr_sk = ca.ca_address_sk
AND cd_demo_sk = c.c_current_cdemo_sk
AND exists (
SELECT  *
FROM store_sales, date_dim
WHERE c.c_customer_sk = ss_customer_sk
AND ss_sold_date_sk = d_date_sk
AND d_year = 1999
AND d_qoy < 4) AND exists (
SELECT  *
FROM
(
	SELECT  ws_bill_customer_sk customsk
	FROM web_sales, date_dim
	WHERE ws_sold_date_sk = d_date_sk
	AND d_year = 1999
	AND d_qoy < 4 
	UNION ALL
	SELECT  cs_ship_customer_sk customsk
	FROM catalog_sales, date_dim
	WHERE cs_sold_date_sk = d_date_sk
	AND d_year = 1999
	AND d_qoy < 4
)x
WHERE x.customsk = c.c_customer_sk)
GROUP BY  ca_state
         ,cd_gender
         ,cd_marital_status
         ,cd_dep_count
         ,cd_dep_employed_count
         ,cd_dep_college_count
ORDER BY ca_state
         ,cd_gender
         ,cd_marital_status
         ,cd_dep_count
         ,cd_dep_employed_count
         ,cd_dep_college_count;