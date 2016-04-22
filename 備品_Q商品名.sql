WITH

v0 AS
(
SELECT DISTINCT
    a.部門コード
,	b.システム名
,	b.資材
,	a.大分類コード
,	a.中分類コード
,	a.小分類コード
,	b.分類コード
,	b.大分類名
,	b.中分類名
,	b.小分類名
,	b.分類名
,	a.商品名
,	a.メーカー
,
	case
		when len(a.大分類コード) = 2
		then isnull(bp.支払先略称,a.メーカー)
		else a.メーカー
	end
	as 支払先
,	a.単位
,	a.単価
,	a.安全在庫数量
,	a.備考
,	a.在庫管理
,	a.登録部門コード
,	a.登録社員コード
,	a.登録区分
,	a.登録日時
FROM
    備品_T商品名 AS a
INNER JOIN
	備品_Q分類 AS b
	ON b.大分類コード = a.大分類コード
	AND b.中分類コード = a.中分類コード
	AND b.小分類コード = a.小分類コード
LEFT OUTER JOIN
	支払先_T as bp
	on bp.支払先名 = a.メーカー
)

SELECT
	*
FROM
	v0 AS v000
