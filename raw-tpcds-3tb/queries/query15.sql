/* TPC-DS query15.tpl 0.57 */
SELECT  ca_zip
       ,SUM(cs_sales_price)
FROM catalog_sales , customer , customer_address , date_dim
WHERE cs_bill_customer_sk = c_customer_sk
AND c_current_addr_sk = ca_address_sk
AND ( substring(ca_zip, 1, 5) IN ('85669', '86197', '88274', '83405', '86475', '85392', '85460', '80348', '81792') or ca_state IN ('CA', 'WA', 'GA') or cs_sales_price > 500)
AND cs_sold_date_sk = d_date_sk
AND d_qoy = 1
AND d_year = 2002
GROUP BY  ca_zip
ORDER BY ca_zip;