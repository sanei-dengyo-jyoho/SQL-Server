with

x0 as
(
select
	[コンピュータ分類№]
,	コンピュータ分類
,	[コンピュータタイプ№]
,	コンピュータタイプ
,	[機器名№]
,	機器名
,	メーカ名
,	機器の停止
,	保守
,	資産
,	種類の停止

from
	コンピュータ機器一覧_Q as x00

where
	( [コンピュータ分類№] >= 0 )
	and ( [コンピュータタイプ№] >= 0 )
	and ( [機器名№] >= 0 )
)
,

v0 as
(
select
	convert(varchar(10),a0.日付,111) as 日付
,	a0.[コンピュータ管理№]
,	a0.ネットワーク数
,	a0.部門コード
,	a0.社員コード
,	convert(varchar(10),a0.設置日,111) as 設置日
,	a0.ドメイン名
,	a0.IP1
,	a0.IP2
,	a0.IP3
,	a0.IP4
,	a0.コンピュータ名
,	a0.端末名
,	a0.フロア
,	a0.機能
,	a0.備考
,	a0.[接続コンピュータ管理№]
,	a0.接続ネットワーク数
,	a0.IP1SORT
,	a0.IP2SORT
,	a0.IP3SORT
,	a0.IP4SORT
,	a0.登録区分
,	a0.異動区分
,	a0.最新区分

from
	コンピュータ異動_T履歴 as a0
inner join
	コンピュータ振出_T as b0
	on b0.[コンピュータ管理№] = a0.[コンピュータ管理№]
	and b0.ネットワーク数 = a0.ネットワーク数
)
,

v1 as
(
select
	datepart(year,a1.日付)*100+datepart(month,a1.日付) as 年月
,	a1.日付
,	c1.[コンピュータ分類№]
,	c1.コンピュータ分類
,	c1.[コンピュータタイプ№]
,	c1.コンピュータタイプ
,	convert(int,c1.[機器名№]) as [機器名№]
,	c1.機器名
,	c1.メーカ名
,	a1.[コンピュータ管理№]
,	a1.ネットワーク数
,	a1.部門コード
,	d1.部門名
,	d1.部門名略称
,	d1.部門名省略
,	a1.社員コード
,	e1.氏名
,	e1.氏
,	e1.名
,	e1.性別
,	a1.設置日
,	a1.ドメイン名
,	a1.IP1
,	a1.IP2
,	a1.IP3
,	a1.IP4
,	dbo.FuncMakeComputerIPAddress(isnull(a1.IP1,0),isnull(a1.IP2,0),isnull(a1.IP3,0),isnull(a1.IP4,0),DEFAULT) as IPアドレス
,	a1.コンピュータ名
,	s1.基本ソフト分類
,	s1.基本ソフト名
,	a1.端末名
,	a1.フロア
,	a1.機能
,	a1.備考
,	dbo.FuncMakeComputerUseString(isnull(d1.部門名省略,''),isnull(a1.フロア,''),isnull(e1.氏,''),isnull(a1.備考,'')) as 利用
,	a1.[接続コンピュータ管理№]
,	a1.接続ネットワーク数
,	a1.IP1SORT
,	a1.IP2SORT
,	a1.IP3SORT
,	a1.IP4SORT
,	a1.登録区分
,	a1.異動区分
,	a1.最新区分
,	f1.コンピュータ履歴 as 履歴

from
	v0 as a1
LEFT OUTER JOIN
	コンピュータ振出_T as b1
	on b1.[コンピュータ管理№] = a1.[コンピュータ管理№]
	and b1.ネットワーク数 = a1.ネットワーク数
LEFT OUTER JOIN
	コンピュータ振出_T基本ソフト as s1
	on s1.[コンピュータ管理№] = b1.[コンピュータ管理№]
	and s1.ネットワーク数 = b1.ネットワーク数
LEFT OUTER JOIN
	x0 as c1
	on c1.機器名 = b1.機器名
LEFT OUTER JOIN
	部門_Q最新 as d1
	on d1.部門コード = a1.部門コード
LEFT OUTER JOIN
	社員_T as e1
	on e1.社員コード = a1.社員コード
LEFT OUTER JOIN
	コード登録区分_Q as f1
	on f1.登録区分 = a1.登録区分
)

select
	*

from
	v1 as v100

