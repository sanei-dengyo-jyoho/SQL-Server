with

v1 as
(
select
	p0.会社コード
,	p0.社員コード
,	p0.運転許可コード
,	b0.運転許可名
,	p0.発行日
,	p0.発行年度
,	p0.発行年月
,	p0.停止日
,	p0.停止年度
,	p0.停止年月
,	dbo.FuncDeleteCharPrefix(l0.リスト,default) as 車両種別選択
,
	-- カンマ区切りの文字に改行コード（CR+LF）を追加する --
	replace(
		dbo.FuncDeleteCharPrefix(l0.リスト,default)
		, N'、', concat(N'、',CHAR(13),CHAR(10))
	)
	as 車両種別選択段落
from
	運転許可証_T as p0
inner join
	運転許可コード_T as b0
	on b0.運転許可コード = p0.運転許可コード
-- 複数行のカラムの値から、１つの区切りの文字列を生成 --
outer apply
	(
	select top 100 percent
		concat(N'、',bx.車両種別名)
	from
		運転許可証_T車両種別 as px
	inner join
		運転許可コード_T車両種別 as bx
		on bx.運転許可コード = px.運転許可コード
		and bx.車両種別 = px.車両種別
	where
		( px.会社コード = p0.会社コード )
		and ( px.社員コード = p0.社員コード )
		and ( px.運転許可コード = p0.運転許可コード )
	order by
		px.車両種別
	for XML PATH ('')
	)
	as l0 (リスト)
)

select
	*
from
	v1 as v100
