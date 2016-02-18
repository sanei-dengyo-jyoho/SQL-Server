with

v0 as
(
SELECT
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	count(b0.大分類) as 件数
,	max(a0.確定日付) as 確定日付
,	max(c0.支払日付) as 支払日付
,	sum(c0.支払金額) as 支払金額
FROM
	支払_T as a0
left outer JOIN
	支払_T項目名 as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
left outer JOIN
	支払_T支払先 as c0
	on c0.工事年度 = b0.工事年度
	and c0.工事種別 = b0.工事種別
	and c0.工事項番 = b0.工事項番
	and c0.大分類 = b0.大分類
	and c0.中分類 = b0.中分類
	and c0.小分類 = b0.小分類
group by
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
)

SELECT
	*
FROM
	v0 as v000
