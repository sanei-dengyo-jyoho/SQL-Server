with

v0 as
(
SELECT
	大分類コード
,	中分類コード
,	小分類コード
,	大分類名
,	中分類名
,	小分類名
,
	大分類コード +
	中分類コード +
	小分類コード
	AS 分類コード
,
	N'（' + 大分類名 + N'）' +
	中分類名 +
	N'【' + 小分類名 + N'】'
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
