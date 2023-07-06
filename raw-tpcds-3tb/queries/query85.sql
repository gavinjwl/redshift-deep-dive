/* TPC-DS query85.tpl 0.33 */
SELECT  substring(r_reason_desc,1,20)
       ,AVG(ws_quantity)
       ,AVG(wr_refunded_cash)
       ,AVG(wr_fee)
FROM web_sales, web_returns, web_page, customer_demographics cd1, customer_demographics cd2, customer_address, date_dim, reason
WHERE ws_web_page_sk = wp_web_page_sk
AND ws_item_sk = wr_item_sk
AND ws_order_number = wr_order_number
AND ws_sold_date_sk = d_date_sk
AND d_year = 2000
AND cd1.cd_demo_sk = wr_refunded_cdemo_sk
AND cd2.cd_demo_sk = wr_returning_cdemo_sk
AND ca_address_sk = wr_refunded_addr_sk
AND r_reason_sk = wr_reason_sk
AND ( ( cd1.cd_marital_status = 'S' AND cd1.cd_marital_status = cd2.cd_marital_status AND cd1.cd_education_status = 'Secondary' AND cd1.cd_education_status = cd2.cd_education_status AND ws_sales_price BETWEEN 100.00 AND 150.00 ) or ( cd1.cd_marital_status = 'U' AND cd1.cd_marital_status = cd2.cd_marital_status AND cd1.cd_education_status = 'Advanced Degree' AND cd1.cd_education_status = cd2.cd_education_status AND ws_sales_price BETWEEN 50.00 AND 100.00 ) or ( cd1.cd_marital_status = 'W' AND cd1.cd_marital_status = cd2.cd_marital_status AND cd1.cd_education_status = '4 yr Degree' AND cd1.cd_education_status = cd2.cd_education_status AND ws_sales_price BETWEEN 150.00 AND 200.00 ) )
AND ( ( ca_country = 'United States' AND ca_state IN ('VA', 'MI', 'ID') AND ws_net_profit BETWEEN 100 AND 200 ) or ( ca_country = 'United States' AND ca_state IN ('TX', 'LA', 'KS') AND ws_net_profit BETWEEN 150 AND 300 ) or ( ca_country = 'United States' AND ca_state IN ('IA', 'NY', 'NM') AND ws_net_profit BETWEEN 50 AND 250 ) )
GROUP BY  r_reason_desc
ORDER BY substring(r_reason_desc,1,20)
         ,AVG(ws_quantity)
         ,AVG(wr_refunded_cash)
         ,AVG(wr_fee);