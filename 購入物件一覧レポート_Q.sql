with

q0 as
(
select
	[コンピュータ管理№]
,	min(ネットワーク数) as ネットワーク数

from
	コンピュータ異動_T as q00

group by
	[コンピュータ管理№]
)
,

q1 as
(
select
	[コンピュータ管理№]
,	min(ネットワーク数) as ネットワーク数

from
	コンピュータ振出_T as q10

group by
	[コンピュータ管理№]
)
,

v0 as
(
select
	a0.[コンピュータ管理№]
,	a0.部門コード
,	a0.社員コード
,	a0.IP1
,	a0.IP2
,	a0.IP3
,	a0.IP4
,	a0.フロア
,	a0.備考

from
	コンピュータ異動_T as a0
inner join
	q0 as b0
	on b0.[コンピュータ管理№] = a0.[コンピュータ管理№]
	and b0.ネットワーク数 = a0.ネットワーク数
)
,

v1 as
(
select
	a1.[コンピュータ管理№]
,	a1.機器名

from
	コンピュータ振出_T as a1
inner join
	q1 as b1
	on b1.[コンピュータ管理№] = a1.[コンピュータ管理№]
	and b1.ネットワーク数 = a1.ネットワーク数
)
,

v2 as
(
select
	a2.年度
,	a2.[管理№]
,	substring(convert(varchar(4),1000 + a2.[管理№]),2,3) as 管理番号
,	a2.契約番号
,	a2.契約種別
,	a2.売主名
,	a2.契約年度
,	a2.契約日
,	a2.購入年度
,	a2.購入日
,	convert(money,isnull(a2.総額,0)) as 総額
,	convert(money,isnull(a2.総額消費税,0)) as 総額消費税
,	a2.備考
,	c2.[コンピュータ管理№]
,	c2.[コンピュータ管理№] as コンピュータ管理番号
,	e2.機器名
,	m2.[元コンピュータ管理№] as [異動元コンピュータ管理№]
,	m2.[元コンピュータ管理№] as 異動元コンピュータ管理番号
,	n2.機器名 as 異動元機器名
,	1 as 台数
,	case isnull(d2.部門コード,'') when '' then 0 else 1 end as 設置済
,	case isnull(d2.部門コード,'') when '' then 1 else 0 end as 保留中
,	d2.部門コード
,	d2.社員コード
,	dbo.FuncMakeComputerUseString(isnull(f2.部門名省略,''),isnull(d2.フロア,''),'','') as 部門名
,	g2.氏名 as 社員名
,	d2.備考 as 異動備考
,	d2.IP1
,	d2.IP2
,	d2.IP3
,	d2.IP4
,	dbo.FuncMakeComputerIPAddress(isnull(d2.IP1,0),isnull(d2.IP2,0),isnull(d2.IP3,0),isnull(d2.IP4,0),DEFAULT) as IPアドレス

from
	購入契約_T as a2
LEFT OUTER JOIN
	購入物件_T as c2
	on c2.年度 = a2.年度
	and c2.[管理№] = a2.[管理№]
LEFT OUTER JOIN
	購入物件_T異動 as m2
	on m2.年度 = c2.年度
	and m2.[管理№] = c2.[管理№]
	and m2.[コンピュータ管理№] = c2.[コンピュータ管理№]
LEFT OUTER JOIN
	v1 as n2
	on n2.[コンピュータ管理№] = m2.[元コンピュータ管理№]
LEFT OUTER JOIN
	v0 as d2
	on d2.[コンピュータ管理№] = c2.[コンピュータ管理№]
LEFT OUTER JOIN
	v1 as e2
	on e2.[コンピュータ管理№] = c2.[コンピュータ管理№]
LEFT OUTER JOIN
	部門_Q最新 as f2
	on f2.部門コード = d2.部門コード
LEFT OUTER JOIN
	社員_T as g2
	on g2.社員コード = d2.社員コード
)

select
	*

from
	v2 as v200

