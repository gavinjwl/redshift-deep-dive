/* TPC-DS query90.tpl 0.40 */
SELECT  cast(amc AS decimal(15,4))/cast(pmc AS decimal(15,4)) am_pm_ratio
FROM
(
	SELECT  COUNT(*) amc
	FROM web_sales, household_demographics , time_dim, web_page
	WHERE ws_sold_time_sk = time_dim.t_time_sk
	AND ws_ship_hdemo_sk = household_demographics.hd_demo_sk
	AND ws_web_page_sk = web_page.wp_web_page_sk
	AND time_dim.t_hour BETWEEN 7 AND 7+1
	AND household_demographics.hd_dep_count = 9
	AND web_page.wp_char_count BETWEEN 5000 AND 5200
) at, (
SELECT  COUNT(*) pmc
FROM web_sales, household_demographics , time_dim, web_page
WHERE ws_sold_time_sk = time_dim.t_time_sk
AND ws_ship_hdemo_sk = household_demographics.hd_demo_sk
AND ws_web_page_sk = web_page.wp_web_page_sk
AND time_dim.t_hour BETWEEN 18 AND 18+1
AND household_demographics.hd_dep_count = 9
AND web_page.wp_char_count BETWEEN 5000 AND 5200) pt
ORDER BY am_pm_ratio;