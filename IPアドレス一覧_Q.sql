with

v2 as
(
select distinct
	a2.ドメイン名
,	a2.IP1
,	a2.IP2
,	a2.IP3
,	a2.IP4
,	dbo.FuncMakeComputerIPAddress(
		isnull(a2.IP1,0),
		isnull(a2.IP2,0),
		isnull(a2.IP3,0),
		isnull(a2.IP4,0),
		DEFAULT
	)
	as IPアドレス
,
	case
		when isnull(b2.[コンピュータ管理№],'') = ''
		then 0
		else 1
	end
	as 設置
,	b2.[コンピュータ管理№]
,	b2.ネットワーク数
,	b2.設置日
,	b2.[コンピュータ分類№]
,	b2.コンピュータ分類
,	b2.[コンピュータタイプ№]
,	b2.コンピュータタイプ識別
,	b2.コンピュータタイプ
,	b2.機器名
,	b2.メーカ名
,	b2.集計部門コード
,	b2.部門コード
,	b2.社員コード
,	b2.利用
from
	(
	select distinct
		a1.ドメイン名
	,	a1.IP1
	,	a1.IP2
	,	a1.IP3
	,	b1.IP4
	from
		(
		select
			a0.ドメイン名
		,	a0.IP1
		,	a0.IP2
		,	a0.IP3
		from
			ドメイン名_T部門 as a0
		group by
			a0.ドメイン名
		,	a0.IP1
		,	a0.IP2
		,	a0.IP3
		)
		as a1
	cross join
		IP4_T as b1
	)
	as a2
left join
	コンピュータ設置一覧_Q as b2
	on b2.ドメイン名 = a2.ドメイン名
	and b2.IP1 = a2.IP1
	and b2.IP2 = a2.IP2
	and b2.IP3 = a2.IP3
	and b2.IP4 = a2.IP4
)

select
	*
from
	v2 as v200
