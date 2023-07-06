/* TPC-DS query24.tpl 0.92 */
WITH ssales AS
(
	SELECT  c_last_name
	       ,c_first_name
	       ,s_store_name
	       ,ca_state
	       ,s_state
	       ,i_color
	       ,i_current_price
	       ,i_manager_id
	       ,i_units
	       ,i_size
	       ,SUM(ss_sales_price) netpaid
	FROM store_sales , store_returns , store , item , customer , customer_address
	WHERE ss_ticket_number = sr_ticket_number
	AND ss_item_sk = sr_item_sk
	AND ss_customer_sk = c_customer_sk
	AND ss_item_sk = i_item_sk
	AND ss_store_sk = s_store_sk
	AND c_current_addr_sk = ca_address_sk
	AND c_birth_country <> upper(ca_country)
	AND s_zip = ca_zip
	AND s_market_id = 5
	GROUP BY  c_last_name
	         ,c_first_name
	         ,s_store_name
	         ,ca_state
	         ,s_state
	         ,i_color
	         ,i_current_price
	         ,i_manager_id
	         ,i_units
	         ,i_size
)
SELECT  c_last_name
       ,c_first_name
       ,s_store_name
       ,SUM(netpaid) paid
FROM ssales
WHERE i_color = 'gainsboro'
GROUP BY  c_last_name
         ,c_first_name
         ,s_store_name
HAVING SUM(netpaid) > (
SELECT  0.05*AVG(netpaid)
FROM ssales)
ORDER BY c_last_name , c_first_name , s_store_name;

/* TPC-DS query24.tpl 0.92 part2 */
WITH  ssales AS
(
	SELECT  c_last_name
	       ,c_first_name
	       ,s_store_name
	       ,ca_state
	       ,s_state
	       ,i_color
	       ,i_current_price
	       ,i_manager_id
	       ,i_units
	       ,i_size
	       ,SUM(ss_sales_price) netpaid
	FROM store_sales , store_returns , store , item , customer , customer_address
	WHERE ss_ticket_number = sr_ticket_number
	AND ss_item_sk = sr_item_sk
	AND ss_customer_sk = c_customer_sk
	AND ss_item_sk = i_item_sk
	AND ss_store_sk = s_store_sk
	AND c_current_addr_sk = ca_address_sk
	AND c_birth_country <> upper(ca_country)
	AND s_zip = ca_zip
	AND s_market_id = 5
	GROUP BY  c_last_name
	         ,c_first_name
	         ,s_store_name
	         ,ca_state
	         ,s_state
	         ,i_color
	         ,i_current_price
	         ,i_manager_id
	         ,i_units
	         ,i_size
)
SELECT  c_last_name
       ,c_first_name
       ,s_store_name
       ,SUM(netpaid) paid
FROM ssales
WHERE i_color = 'light'
GROUP BY  c_last_name
         ,c_first_name
         ,s_store_name
HAVING SUM(netpaid) > (
SELECT  0.05*AVG(netpaid)
FROM ssales)
ORDER BY c_last_name , c_first_name , s_store_name;