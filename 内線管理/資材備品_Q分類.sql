with

v0 as
(
SELECT
	CONVERT(int,大分類コード) AS 大分類コード
,	CONVERT(int,中分類コード) AS 中分類コード
,	CONVERT(int,小分類コード) AS 小分類コード
,	大分類名
,	中分類名
,	小分類名
,
	FORMAT(CONVERT(int,大分類コード),'D4') +
	FORMAT(CONVERT(int,中分類コード),'D4') +
	FORMAT(CONVERT(int,小分類コード),'D4')
	AS 分類コード
,
	N'（' +
	大分類名 +
	N'）' +
	中分類名 +
	N'【' +
	小分類名 +
	N'】'
	AS 分類名
,	資材
FROM
	備品_T分類 as a0
WHERE
	( isnull(利用,0) <> 0 )
	AND ( isnull(資材,0) <> 0 )
)

select
	*
from
	v0 as a1
