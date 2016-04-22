with

v1 as
(
select
	b0.運転許可コード
,	b0.運転許可名
,	b0.運転許可説明
,	b0.運転許可接頭語
,	b0.更新日時
,	dbo.FuncDeleteCharPrefix(l0.リスト,default) as 運転許可車両種別
,
	-- カンマ区切りの文字に改行コード（CR+LF）を追加する --
	replace(
		dbo.FuncDeleteCharPrefix(l0.リスト,default)
		, N'、', concat(N'、',CHAR(13),CHAR(10))
	)
	as 運転許可車両種別段落
from
	運転許可コード_T as b0
-- 複数行のカラムの値から、１つの区切りの文字列を生成 --
outer apply
	(
	select TOP 100 PERCENT
		concat(N'、',bx.車両種別名)
	from
		運転許可コード_T車両種別 as bx
	where
		( bx.運転許可コード = b0.運転許可コード )
	order by
		bx.車両種別
	FOR XML PATH ('')
	)
	as l0 (リスト)
)

select
	*
from
	v1 as v100
