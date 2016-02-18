with

v0 as
(
select
	q0.部門コード
,	q0.大分類コード
,	q0.中分類コード
,	q0.小分類コード
,	q9.大分類名
,	q9.中分類名
,	q9.小分類名
,	q9.分類コード
,	q9.分類名
,	q0.商品名
,	q0.メーカー
,	q0.単位
,	isnull(q0.単価,isnull(q1.単価,null)) as 単価
,	isnull(q1.数量,0) as 数量
,	isnull(q0.安全在庫数量,0) as 安全在庫数量
,	q0.備考
from
	備品_T商品名 as q0
LEFT OUTER JOIN
	備品_T在庫 as q1
	on q1.部門コード=q0.部門コード
	and q1.大分類コード=q0.大分類コード
	and q1.中分類コード=q0.中分類コード
	and q1.小分類コード=q0.小分類コード
	and q1.商品名=q0.商品名
LEFT OUTER JOIN
	備品_Q分類 as q9
	on q9.大分類コード=q0.大分類コード
	and q9.中分類コード=q0.中分類コード
	and q9.小分類コード=q0.小分類コード
)
,

v1 as
(
select
	部門コード
,	大分類コード
,	中分類コード
,	小分類コード
,	大分類名
,	中分類名
,	小分類名
,	分類コード
,	分類名
,	商品名
,	メーカー
,	単位
,	単価
,	数量
,	isnull(単価,0) * 数量 as 金額
,	安全在庫数量
,
	case
		数量
		when 0
		then 9
		else
			case
				when 数量 < 安全在庫数量
				then 8
				else 0
			end
	end
	as 警告
,	備考
from
	v0 as v00
)

select
	*
from
	v1 as a
