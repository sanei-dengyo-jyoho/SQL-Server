WITH

v0 AS
(
SELECT
    c0.システム名
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.工期自日付
,	a0.工期至日付
FROM
    工事台帳_T AS a0
LEFT OUTER JOIN
    工事種別_T AS c0
    ON c0.工事種別 = a0.工事種別
)
,

v2 AS
(
SELECT
    a2.システム名
,	a2.工事年度
,	a2.工事種別
,	a2.工事項番
,	b2.大分類
,	b2.中分類
,	b2.小分類
,	b2.項目名
,	b2.支払先1
,	b2.支払先2
,	b2.支払金額
,	CASE
		WHEN ISNULL(b2.支払自日付,a2.工期自日付) < a2.工期自日付
		THEN ISNULL(b2.支払自日付, a2.工期自日付)
		ELSE a2.工期自日付
	END AS 支払自日付
,	CASE
		WHEN ISNULL(b2.支払至日付, a2.工期至日付) > a2.工期至日付
		THEN ISNULL(b2.支払至日付, a2.工期至日付)
		ELSE a2.工期至日付
	END AS 支払至日付
,	b2.確定日付
,	CASE
		WHEN b2.工事項番 IS NULL
		THEN NULL
		WHEN b2.確定日付 IS NULL
		THEN 1
		ELSE - 1
	END AS 支払状況
FROM
    v0 AS a2
LEFT OUTER JOIN
    支払_Q項目名 AS b2
	ON b2.工事年度 = a2.工事年度
	AND b2.工事種別 = a2.工事種別
	AND b2.工事項番 = a2.工事項番
)

SELECT
    *
FROM
	v2 AS v300
