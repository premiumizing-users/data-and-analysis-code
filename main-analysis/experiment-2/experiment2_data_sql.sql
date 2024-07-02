SELECT
ROW_NUMBER() OVER (ORDER BY a.uid) AS unique_id,
c.test_bucket,
CASE
WHEN UPPER(b.country) IN ('CN','CY','NO','DK','HK','KW','NZ','CH','PR','TW','AT','US','JP','KR') then 'Country tier 1'
WHEN UPPER(b.country) IN ('GB','QA','NL','GE','SG','MY','SE','IE','DE','AU','CA','LT','RS','SI','FR','FI','EE','BE','LU') then 'Country tier 2'
WHEN UPPER(b.country) IN ('UZ','VN','HR','IT','IS','ZA','GR','IN','SK','IQ','PT','BH','KZ','TH','MM','CZ','AE','ES','KH','RU') then 'Country tier 3'
ELSE 'Country tier 4'
END country_tier,
a.d1_revenue,
a.d3_revenue,
a.d7_revenue,
a.d14_revenue,
a.d30_revenue,
a.d1_net_revenue,
a.d3_net_revenue,
a.d7_net_revenue,
a.d14_net_revenue,
a.d30_net_revenue,
a.d1_conversion,
a.d3_conversion,
a.d7_conversion,
a.d14_conversion,
a.d30_conversion,
a.d1_purchases,
a.d3_purchases,
a.d7_purchases,
a.d14_purchases,
a.d30_purchases,
a.d1_minutes,
a.d3_minutes,
a.d7_minutes,
a.d14_minutes,
a.d30_minutes,
a.d1_sessions,
a.d3_sessions,
a.d7_sessions,
a.d14_sessions,
a.d30_sessions,
b.d1_ad_views,
b.d3_ad_views,
b.d7_ad_views,
b.d14_ad_views,
b.d30_ad_views,
b.d1_guild_join,
b.d3_guild_join,
b.d7_guild_join,
b.d14_guild_join,
b.d30_guild_join,
b.d1_chat_messages,
b.d3_chat_messages,
b.d7_chat_messages,
b.d14_chat_messages,
b.d30_chat_messages,
b.d1_rounds_played,
b.d3_rounds_played,
b.d7_rounds_played,
b.d14_rounds_played,
b.d30_rounds_played,
b.d1_retention,
b.d3_retention,
b.d7_retention,
b.d14_retention,
b.d30_retention,
d.d1_hp_step1_revenue d1_offer_step1_revenue,
d.d3_hp_step1_revenue d3_offer_step1_revenue,
d.d7_hp_step1_revenue d7_offer_step1_revenue,
d.d14_hp_step1_revenue d14_offer_step1_revenue,
d.d30_hp_step1_revenue d30_offer_step1_revenue,
d.d1_hp_step2_revenue d1_offer_step2_revenue,
d.d3_hp_step2_revenue d3_offer_step2_revenue,
d.d7_hp_step2_revenue d7_offer_step2_revenue,
d.d14_hp_step2_revenue d14_offer_step2_revenue,
d.d30_hp_step2_revenue d30_offer_step2_revenue,
b.d1_gem_spend d1_gem_spend,
b.d3_gem_spend d3_gem_spend,
b.d7_gem_spend d7_gem_spend,
b.d14_gem_spend d14_gem_spend,
b.d30_gem_spend d30_gem_spend
FROM

(SELECT
uid,
CAST(ujd AS DATE) join_date,
ujd joints,
d1_revenue,
d3_revenue,
d7_revenue,
d14_revenue,
d30_revenue,
d1_net_revenue,
d3_net_revenue,
d7_net_revenue,
d14_net_revenue,
d30_net_revenue,
CASE WHEN d1_revenue > 0 THEN 1 ELSE 0 END d1_conversion,
CASE WHEN d3_revenue > 0 THEN 1 ELSE 0 END d3_conversion,
CASE WHEN d7_revenue > 0 THEN 1 ELSE 0 END d7_conversion,
CASE WHEN d14_revenue > 0 THEN 1 ELSE 0 END d14_conversion,
CASE WHEN d30_revenue > 0 THEN 1 ELSE 0 END d30_conversion,
d1_transactions d1_purchases,
d3_transactions d3_purchases,
d7_transactions d7_purchases,
d14_transactions d14_purchases,
d30_transactions d30_purchases,
d1_play_time/60 d1_minutes,
d3_play_time/60 d3_minutes,
d7_play_time/60 d7_minutes,
d14_play_time/60 d14_minutes,
d30_play_time/60 d30_minutes,
d1_sessions,
d3_sessions,
d7_sessions,
d14_sessions,
d30_sessions
FROM
`app-schema.com_app.user_profile`
WHERE
CAST(ujd AS DATE) >= DATE('2018-10-09')
AND CAST(ujd AS DATE) <= DATE_ADD(CURRENT_DATE(), INTERVAL -8 DAY)
AND device_os = 'ios') a

LEFT JOIN
(SELECT
uid,
MAX(CASE WHEN CAST(join_date AS DATE) = CAST(date AS DATE) THEN country ELSE NULL END) country,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 1 THEN player_joined_guild ELSE 0 END) d1_guild_join,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 3 THEN player_joined_guild ELSE 0 END) d3_guild_join,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 7 THEN player_joined_guild ELSE 0 END) d7_guild_join,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 14 THEN player_joined_guild ELSE 0 END) d14_guild_join,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 30 THEN player_joined_guild ELSE 0 END) d30_guild_join,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 1 THEN player_guildchatmessage ELSE 0 END) d1_chat_messages,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 3 THEN player_guildchatmessage ELSE 0 END) d3_chat_messages,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 7 THEN player_guildchatmessage ELSE 0 END) d7_chat_messages,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 14 THEN player_guildchatmessage ELSE 0 END) d14_chat_messages,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 30 THEN player_guildchatmessage ELSE 0 END) d30_chat_messages,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 1 THEN COALESCE(guild_giftsend,0)+COALESCE(guild_gifts_sent,0) ELSE 0 END) d1_gifts_sent,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 3 THEN COALESCE(guild_giftsend,0)+COALESCE(guild_gifts_sent,0) ELSE 0 END) d3_gifts_sent,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 7 THEN COALESCE(guild_giftsend,0)+COALESCE(guild_gifts_sent,0) ELSE 0 END) d7_gifts_sent,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 14 THEN COALESCE(guild_giftsend,0)+COALESCE(guild_gifts_sent,0) ELSE 0 END) d14_gifts_sent,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 30 THEN COALESCE(guild_giftsend,0)+COALESCE(guild_gifts_sent,0) ELSE 0 END) d30_gifts_sent,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 1 THEN mission_start ELSE 0 END) d1_rounds_played,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 3 THEN mission_start ELSE 0 END) d3_rounds_played,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 7 THEN mission_start ELSE 0 END) d7_rounds_played,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 14 THEN mission_start ELSE 0 END) d14_rounds_played,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 30 THEN mission_start ELSE 0 END) d30_rounds_played,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) = 1 AND COALESCE(sessions,0) > 0 THEN 1 ELSE 0 END) d1_retention,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) = 3 AND COALESCE(sessions,0) > 0 THEN 1 ELSE 0 END) d3_retention,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) = 7 AND COALESCE(sessions,0) > 0 THEN 1 ELSE 0 END) d7_retention,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) = 14 AND COALESCE(sessions,0) > 0 THEN 1 ELSE 0 END) d14_retention,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) = 30 AND COALESCE(sessions,0) > 0 THEN 1 ELSE 0 END) d30_retention,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 1 THEN gem_spend ELSE 0 END) d1_gem_spend,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 3 THEN gem_spend ELSE 0 END) d3_gem_spend,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 7 THEN gem_spend ELSE 0 END) d7_gem_spend,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 14 THEN gem_spend ELSE 0 END) d14_gem_spend,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 30 THEN gem_spend ELSE 0 END) d30_gem_spend,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 1 THEN ad_views ELSE 0 END) d1_ad_views,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 3 THEN ad_views ELSE 0 END) d3_ad_views,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 7 THEN ad_views ELSE 0 END) d7_ad_views,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 14 THEN ad_views ELSE 0 END) d14_ad_views,
MAX(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 30 THEN ad_views ELSE 0 END) d30_ad_views,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 1 THEN revenue ELSE 0 END) d1_rev_ds,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 3 THEN revenue ELSE 0 END) d3_rev_ds,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 7 THEN revenue ELSE 0 END) d7_rev_ds,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 14 THEN revenue ELSE 0 END) d14_rev_ds,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 30 THEN revenue ELSE 0 END) d30_rev_ds,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 1 THEN net_revenue ELSE 0 END) d1_net_rev_ds,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 3 THEN net_revenue ELSE 0 END) d3_net_rev_ds,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 7 THEN net_revenue ELSE 0 END) d7_net_rev_ds,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 14 THEN net_revenue ELSE 0 END) d14_net_rev_ds,
SUM(CASE WHEN DATE_DIFF(CAST(date AS DATE),CAST(join_date AS DATE),DAY) BETWEEN 0 AND 30 THEN net_revenue ELSE 0 END) d30_net_rev_ds
FROM
`app-schema.DS.DS_daily`
WHERE
CAST(join_date AS DATE) >= DATE('2018-10-09')
AND CAST(join_date AS DATE) <= DATE_ADD(CURRENT_DATE(), INTERVAL -8 DAY)
GROUP BY
1) b
ON a.uid = b.uid

LEFT JOIN
(SELECT
uid,
MIN(test_bucket) test_bucket
FROM
(SELECT
uid,
CASE WHEN SAFE.SUBSTR(ab_bucket, 0, 13) = 'starterpack_pers' THEN 'Personalized'
WHEN SAFE.SUBSTR(ab_bucket, 0, 13) = 'starterpack_flat' THEN 'Hold-out'
END test_bucket
FROM
`app-schema.AB_TESTING.AB_buckets_summary`
WHERE
SAFE.SUBSTR(ab_test_group,0,13) = 'starterpack_pers'
AND ab_test_group NOT LIKE '%grouped%'
AND ujd = min_date_in_bucket
AND CAST(ujd AS DATE) >= DATE('2018-10-09')
AND CAST(ujd AS DATE) <= DATE_ADD(CURRENT_DATE(), INTERVAL -8 DAY)
GROUP BY
1,2)
GROUP BY
1) c
ON a.uid = c.uid

LEFT JOIN
(SELECT
uid,
SUM(d1_hp_step1_revenue) d1_hp_step1_revenue,
SUM(d3_hp_step1_revenue) d3_hp_step1_revenue,
SUM(d7_hp_step1_revenue) d7_hp_step1_revenue,
SUM(d14_hp_step1_revenue) d14_hp_step1_revenue,
SUM(d30_hp_step1_revenue) d30_hp_step1_revenue,
SUM(d1_hp_step2_revenue) d1_hp_step2_revenue,
SUM(d3_hp_step2_revenue) d3_hp_step2_revenue,
SUM(d7_hp_step2_revenue) d7_hp_step2_revenue,
SUM(d14_hp_step2_revenue) d14_hp_step2_revenue,
SUM(d30_hp_step2_revenue) d30_hp_step2_revenue
FROM
(SELECT
uid,
CASE
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.99',
'com.app.pass.starter.t1')
THEN 0.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.299',
'com.app.pass.starter.t3')
THEN 2.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.499',
'com.app.pass.starter.t5')
THEN 4.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.999',
'com.app.pass.starter.t10')
THEN 9.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.1999',
'com.app.pass.starter.t20')
THEN 19.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.2999',
'com.app.pass.starter.t30')
THEN 29.99
ELSE 0
END d1_hp_step1_revenue,
CASE
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.step2.t3',
'com.app.pass.starter.step2.299')
THEN 2.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.step2.t9',
'com.app.pass.starter.step2.899')
THEN 8.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.step2.1499',
'com.app.pass.starter.step2.t15')
THEN 14.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.step2.2999',
'com.app.pass.starter.step2.t30')
THEN 29.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.step2.5999',
'com.app.pass.starter.step2.t52')
THEN 59.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 1
AND sku IN ('com.app.pass.starter.step2.t58',
'com.app.pass.starter.step2.8999')
THEN 89.99
ELSE 0
END d1_hp_step2_revenue,
CASE
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.99',
'com.app.pass.starter.t1')
THEN 0.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.299',
'com.app.pass.starter.t3')
THEN 2.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.499',
'com.app.pass.starter.t5')
THEN 4.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.999',
'com.app.pass.starter.t10')
THEN 9.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.1999',
'com.app.pass.starter.t20')
THEN 19.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.2999',
'com.app.pass.starter.t30')
THEN 29.99
ELSE 0
END d3_hp_step1_revenue,
CASE
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.step2.t3',
'com.app.pass.starter.step2.299')
THEN 2.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.step2.t9',
'com.app.pass.starter.step2.899')
THEN 8.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.step2.1499',
'com.app.pass.starter.step2.t15')
THEN 14.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.step2.2999',
'com.app.pass.starter.step2.t30')
THEN 29.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.step2.5999',
'com.app.pass.starter.step2.t52')
THEN 59.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 3
AND sku IN ('com.app.pass.starter.step2.t58',
'com.app.pass.starter.step2.8999')
THEN 89.99
ELSE 0
END d3_hp_step2_revenue,
CASE
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.99',
'com.app.pass.starter.t1')
THEN 0.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.299',
'com.app.pass.starter.t3')
THEN 2.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.499',
'com.app.pass.starter.t5')
THEN 4.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.999',
'com.app.pass.starter.t10')
THEN 9.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.1999',
'com.app.pass.starter.t20')
THEN 19.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.2999',
'com.app.pass.starter.t30')
THEN 29.99
ELSE 0
END d7_hp_step1_revenue,
CASE
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.step2.t3',
'com.app.pass.starter.step2.299')
THEN 2.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.step2.t9',
'com.app.pass.starter.step2.899')
THEN 8.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.step2.1499',
'com.app.pass.starter.step2.t15')
THEN 14.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.step2.2999',
'com.app.pass.starter.step2.t30')
THEN 29.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.step2.5999',
'com.app.pass.starter.step2.t52')
THEN 59.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 7
AND sku IN ('com.app.pass.starter.step2.t58',
'com.app.pass.starter.step2.8999')
THEN 89.99
ELSE 0
END d7_hp_step2_revenue,
CASE
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.99',
'com.app.pass.starter.t1')
THEN 0.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.299',
'com.app.pass.starter.t3')
THEN 2.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.499',
'com.app.pass.starter.t5')
THEN 4.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.999',
'com.app.pass.starter.t10')
THEN 9.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.1999',
'com.app.pass.starter.t20')
THEN 19.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.2999',
'com.app.pass.starter.t30')
THEN 29.99
ELSE 0
END d14_hp_step1_revenue,
CASE
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.step2.t3',
'com.app.pass.starter.step2.299')
THEN 2.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.step2.t9',
'com.app.pass.starter.step2.899')
THEN 8.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.step2.1499',
'com.app.pass.starter.step2.t15')
THEN 14.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.step2.2999',
'com.app.pass.starter.step2.t30')
THEN 29.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.step2.5999',
'com.app.pass.starter.step2.t52')
THEN 59.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 14
AND sku IN ('com.app.pass.starter.step2.t58',
'com.app.pass.starter.step2.8999')
THEN 89.99
ELSE 0
END d14_hp_step2_revenue,
CASE
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.99',
'com.app.pass.starter.t1')
THEN 0.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.299',
'com.app.pass.starter.t3')
THEN 2.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.499',
'com.app.pass.starter.t5')
THEN 4.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.999',
'com.app.pass.starter.t10')
THEN 9.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.1999',
'com.app.pass.starter.t20')
THEN 19.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.2999',
'com.app.pass.starter.t30')
THEN 29.99
ELSE 0
END d30_hp_step1_revenue,
CASE
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.step2.t3',
'com.app.pass.starter.step2.299')
THEN 2.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.step2.t9',
'com.app.pass.starter.step2.899')
THEN 8.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.step2.1499',
'com.app.pass.starter.step2.t15')
THEN 14.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.step2.2999',
'com.app.pass.starter.step2.t30')
THEN 29.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.step2.5999',
'com.app.pass.starter.step2.t52')
THEN 59.99
WHEN DATE_DIFF(CAST(ets AS DATE),CAST(ujd AS DATE),DAY) BETWEEN 0 AND 30
AND sku IN ('com.app.pass.starter.step2.t58',
'com.app.pass.starter.step2.8999')
THEN 89.99
ELSE 0
END d30_hp_step2_revenue
FROM
`app-schema.com_app.iap`
WHERE
CAST(ujd AS DATE) >= DATE('2018-10-09')
AND CAST(ujd AS DATE) <= DATE_ADD(CURRENT_DATE(), INTERVAL -8 DAY))
GROUP BY
1) d
ON a.uid = d.uid

WHERE
c.test_bucket IS NOT NULL
AND a.device_os = 'ios'
AND a.join_date >= DATE('2018-10-09')
AND a.join_date <= DATE('2018-12-04')
