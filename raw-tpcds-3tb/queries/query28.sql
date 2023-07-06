/* TPC-DS query28.tpl 0.36 */
SELECT  *
FROM
(
	SELECT  AVG(ss_list_price) B1_LP
	       ,COUNT(ss_list_price) B1_CNT
	       ,COUNT(distinct ss_list_price) B1_CNTD
	FROM store_sales
	WHERE ss_quantity BETWEEN 0 AND 5
	AND (ss_list_price BETWEEN 85 AND 85+10 or ss_coupon_amt BETWEEN 725 AND 725+1000 or ss_wholesale_cost BETWEEN 18 AND 18+20)
) B1, (
SELECT  AVG(ss_list_price) B2_LP
       ,COUNT(ss_list_price) B2_CNT
       ,COUNT(distinct ss_list_price) B2_CNTD
FROM store_sales
WHERE ss_quantity BETWEEN 6 AND 10
AND (ss_list_price BETWEEN 6 AND 6+10 or ss_coupon_amt BETWEEN 11704 AND 11704+1000 or ss_wholesale_cost BETWEEN 15 AND 15+20)) B2, (
SELECT  AVG(ss_list_price) B3_LP
       ,COUNT(ss_list_price) B3_CNT
       ,COUNT(distinct ss_list_price) B3_CNTD
FROM store_sales
WHERE ss_quantity BETWEEN 11 AND 15
AND (ss_list_price BETWEEN 72 AND 72+10 or ss_coupon_amt BETWEEN 5172 AND 5172+1000 or ss_wholesale_cost BETWEEN 27 AND 27+20)) B3, (
SELECT  AVG(ss_list_price) B4_LP
       ,COUNT(ss_list_price) B4_CNT
       ,COUNT(distinct ss_list_price) B4_CNTD
FROM store_sales
WHERE ss_quantity BETWEEN 16 AND 20
AND (ss_list_price BETWEEN 104 AND 104+10 or ss_coupon_amt BETWEEN 2440 AND 2440+1000 or ss_wholesale_cost BETWEEN 65 AND 65+20)) B4, (
SELECT  AVG(ss_list_price) B5_LP
       ,COUNT(ss_list_price) B5_CNT
       ,COUNT(distinct ss_list_price) B5_CNTD
FROM store_sales
WHERE ss_quantity BETWEEN 21 AND 25
AND (ss_list_price BETWEEN 153 AND 153+10 or ss_coupon_amt BETWEEN 1350 AND 1350+1000 or ss_wholesale_cost BETWEEN 3 AND 3+20)) B5, (
SELECT  AVG(ss_list_price) B6_LP
       ,COUNT(ss_list_price) B6_CNT
       ,COUNT(distinct ss_list_price) B6_CNTD
FROM store_sales
WHERE ss_quantity BETWEEN 26 AND 30
AND (ss_list_price BETWEEN 64 AND 64+10 or ss_coupon_amt BETWEEN 2991 AND 2991+1000 or ss_wholesale_cost BETWEEN 7 AND 7+20)) B6;