/* TPC-DS query72.tpl 0.87 */
SELECT  i_item_desc
       ,w_warehouse_name
       ,d1.d_week_seq
       ,SUM(case WHEN p_promo_sk is null THEN 1 else 0 end) no_promo
       ,SUM(case WHEN p_promo_sk is not null THEN 1 else 0 end) promo
       ,COUNT(*) total_cnt
FROM catalog_sales
JOIN inventory
ON (cs_item_sk = inv_item_sk)
JOIN warehouse
ON (w_warehouse_sk = inv_warehouse_sk)
JOIN item
ON (i_item_sk = cs_item_sk)
JOIN customer_demographics
ON (cs_bill_cdemo_sk = cd_demo_sk)
JOIN household_demographics
ON (cs_bill_hdemo_sk = hd_demo_sk)
JOIN date_dim d1
ON (cs_sold_date_sk = d1.d_date_sk)
JOIN date_dim d2
ON (inv_date_sk = d2.d_date_sk)
JOIN date_dim d3
ON (cs_ship_date_sk = d3.d_date_sk)
LEFT OUTER JOIN promotion
ON (cs_promo_sk = p_promo_sk)
LEFT OUTER JOIN catalog_returns
ON (cr_item_sk = cs_item_sk AND cr_order_number = cs_order_number)
WHERE d1.d_week_seq = d2.d_week_seq
AND inv_quantity_on_hand < cs_quantity
AND d3.d_date > d1.d_date + 5
AND hd_buy_potential = '1001-5000'
AND d1.d_year = 2000
AND cd_marital_status = 'D'
GROUP BY  i_item_desc
         ,w_warehouse_name
         ,d1.d_week_seq
ORDER BY total_cnt desc
         ,i_item_desc
         ,w_warehouse_name
         ,d_week_seq;