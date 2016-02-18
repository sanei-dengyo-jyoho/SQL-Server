with

v0 as
(
SELECT
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.大分類
,	a0.中分類
,	a0.小分類
,	a0.支払日付
,	a0.支払先コード
,	b0.支払先略称 AS 支払先
,	a0.支払金額
FROM
    支払_T支払先 AS a0
INNER JOIN
 	支払先_T AS b0
	ON b0.支払先コード = a0.支払先コード
)

SELECT
	*
FROM
	v0 AS v000
