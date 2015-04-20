with

x0 as
(
select
	[コンピュータ管理№]
,	min(ネットワーク数) as ネットワーク数
,	max(ネットワーク数) as 最大ネットワーク数

from
	コンピュータ振出_T as x00

group by
	[コンピュータ管理№]
)
,

x1 as
(
select
	x11.[コンピュータ管理№]
,	x11.廃止日

from
	x0 as x10
LEFT OUTER JOIN
	コンピュータ振出_T as x11
	on x11.[コンピュータ管理№] = x10.[コンピュータ管理№]
	and x11.ネットワーク数 = x10.ネットワーク数
)
,

x2 as
(
select
	x20.年度
,	x20.[管理№]
,	count(x20.[コンピュータ管理№]) as 台数
,	sum(case isnull(x21.廃止日,'') when '' then 1 else 0 end) as 稼働台数

from
	リース物件_T as x20
LEFT OUTER JOIN
	x1 as x21
	on x21.[コンピュータ管理№] = x20.[コンピュータ管理№]

group by
	x20.年度
,	x20.[管理№]
)
,

v1 as
(
select
	年度
,	[管理№]
,	max(回数) as 最大回数

from
	リース契約_T as a1

group by
	年度
,	[管理№]
)
,

v2 as
(
select
	a2.年度
,	a2.[管理№]
,	a2.回数
,	a2.契約番号
,	a2.契約種別
,	a2.業者名
,	a2.契約年度
,	a2.契約日
,	a2.開始年度
,	a2.開始日
,	a2.終了年度
,	a2.終了日
,	a2.期間月
,	a2.部門コード
,	a2.売主名
,	a2.物件名
,	a2.総額
,	a2.総額消費税
,	a2.月額
,	a2.月額消費税
,	a2.備考
,	a2.参照年度
,	a2.[参照管理№]
,	a2.参照契約種別名
,	c2.最大回数

from
	リース契約_T as a2

inner join
	v1 as c2
	on c2.年度 = a2.年度
	and c2.[管理№] = a2.[管理№]
	and c2.最大回数 = a2.回数
)
,

v3 as
(
select
	a3.年度
,	a3.[管理№]
,	convert(varchar(5),a3.年度) + '-' + substring(convert(varchar(5),10000 + a3.[管理№]),2,4) as [年度-№]
,	a3.回数
,	a3.契約番号
,	a3.契約種別
,	case when a3.回数 = 0 then '' else '再' end + d3.契約種別名 as 契約種別名
,	a3.業者名
,	a3.契約年度
,	a3.契約日
,	a3.開始年度
,	a3.開始日
,	a3.終了年度
,	a3.終了日
,	a3.期間月
,	convert(varchar(10),a3.開始日,111) + '～' + convert(varchar(10),a3.終了日,111) as リース期間
,	case a3.回数 when 0 then '' else '（再）' end + convert(varchar(10),a3.開始日,111) + '～' + convert(varchar(10),a3.終了日,111) as リース期間表示
,	a3.部門コード
,	e3.部門名
,	e3.部門名略称
,	a3.売主名
,	a3.物件名
,	b3.台数
,	b3.稼働台数
,	a3.総額
,	a3.総額消費税
,	a3.月額
,	a3.月額消費税
,	a3.備考
,	a3.参照年度
,	a3.[参照管理№]
,	a3.参照契約種別名
,	a3.最大回数
,	case when isnull(a3.終了日,'') = '' then '' when a3.終了日 < GETDATE() then (case when isnull(a3.参照年度,0) <> 0 and isnull(a3.[参照管理№],0) <> 0 then -9 else 9 end) when isnull(a3.最大回数,0) <> 0 then -1 else 0 end as 警告

from
	v2 as a3
LEFT OUTER JOIN
	x2 as b3
	on b3.年度 = a3.年度
	and b3.[管理№] = a3.[管理№]
LEFT OUTER JOIN
	契約種別_Q as d3
	on d3.契約種別 = a3.契約種別
LEFT OUTER JOIN
	部門_Q最新 as e3
	on e3.部門コード = a3.部門コード

where
	( isnull(b3.台数,0) = 0 )
	or ( isnull(b3.稼働台数,0) > 0 )
)

select
	*

from
	v3 as v300

