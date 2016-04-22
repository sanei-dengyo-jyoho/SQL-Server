with

v2 as
(
select
	a2.年度
,	a2.部門コード
,	a2.[伝票№]
,	dbo.FuncDeleteCharPrefix(l0.リスト,2) as 発注条件選択
from
	備品購入_T as a2
-- 複数行のカラムの値から、１つの区切りの文字列を生成 --
outer apply
    (
    select top 100 percent
        concat(N'、　',x2.発注条件選択)
    from
		(
		select
			a0.発注条件
		,	a0.発注条件順
		,
			concat(
				dbo.FuncMakeCheckBoxString(
					isnull(c0.発注条件,0),
					isnull(a0.発注条件,0)
				),
				a0.発注条件名
			)
			as 発注条件選択
		,	b0.年度
		,	b0.部門コード
		,	b0.[伝票№]
		from
			発注条件_Q as a0
		cross join
			備品購入_T as b0
		left outer join
			備品購入_T発注条件 as c0
			on c0.年度 = b0.年度
			and c0.部門コード = b0.部門コード
			and c0.[伝票№] = b0.[伝票№]
		)
        as x2
    where
        ( x2.年度 = a2.年度 )
        and ( x2.部門コード = a2.部門コード )
        and ( x2.[伝票№] = a2.[伝票№] )
    order by
        x2.発注条件順
    for XML PATH ('')
    )
	as l0 (リスト)
)

select
	*
from
	v2 as v200
