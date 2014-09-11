with

v0 as
(
select
	a0.利用者名
,	a0.オブジェクト名
,	a0.コントロール名 as ドメイン名
,	convert(int,a0.キー1) as 年度
,	convert(int,a0.キー2) as [管理№]
,	convert(int,a0.キー3) as IP1
,	convert(int,a0.キー4) as IP2
,	convert(int,a0.キー5) as IP3
,	b0.IP4

from
	汎用一覧_T as a0
cross join
	IP4_T as b0
)
,


v1 as
(
select
	a1.利用者名
,	a1.オブジェクト名
,	a1.ドメイン名
,	a1.年度
,	a1.[管理№]
,	a1.IP1
,	a1.IP2
,	a1.IP3
,	a1.IP4

from
	v0 as a1
left outer join
	コンピュータ異動_T as b1
	on b1.ドメイン名 = a1.ドメイン名
	and b1.IP1 = a1.IP1
	and b1.IP2 = a1.IP2
	and b1.IP3 = a1.IP3
	and b1.IP4 = a1.IP4

where
	( isnull(b1.[コンピュータ管理№],'') = '' )
)
,

v2 as
(
select distinct
	a2.利用者名
,	a2.オブジェクト名
,	a2.ドメイン名
,	a2.年度
,	a2.[管理№]
,	a2.IP1
,	a2.IP2
,	a2.IP3
,	a2.IP4
,	dbo.FuncMakeComputerIPAddress(isnull(a2.IP1,0),isnull(a2.IP2,0),isnull(a2.IP3,0),isnull(a2.IP4,0),DEFAULT) as IPアドレス
,	isnull(b2.確定済,0) as 確定済
,	c2.[コンピュータ管理№]
,	c2.ネットワーク数
,	isnull(c2.[コンピュータ管理№],'') + '(' + convert(varchar(4),isnull(c2.ネットワーク数,0)) + ')' as [コンピュータ管理№数]
,	c2.設置日
,	c2.旧IP1
,	c2.旧IP2
,	c2.旧IP3
,	c2.旧IP4
,	case isnull(c2.旧IP1,0) + isnull(c2.旧IP2,0) + isnull(c2.旧IP3,0) + isnull(c2.旧IP4,0) when 0 then '' else dbo.FuncMakeComputerIPAddress(isnull(c2.旧IP1,0),isnull(c2.旧IP2,0),isnull(c2.旧IP3,0),isnull(c2.旧IP4,0),DEFAULT) end as 旧IPアドレス
,	d2.[コンピュータ分類№]
,	d2.コンピュータ分類
,	d2.[コンピュータタイプ№]
,	d2.コンピュータタイプ識別
,	d2.コンピュータタイプ
,	d2.機器名
,	d2.メーカ名
,	d2.会社コード
,	d2.集計部門コード
,	d2.設置部門コード
,	d2.部門コード
,	d2.部門名略称
,	d2.社員コード
,	e2.氏名
,	e2.カナ氏名
,	e2.性別
,	case when isnull(e2.社員コード,0) = 0 then -2 else isnull(e2.登録区分,-1) end as 社員登録区分
,	d2.利用

from
	v1 as a2
left outer join
	コンピュータアドレス異動_T as b2
	on b2.年度 = a2.年度
	and b2.[管理№] = a2.[管理№]
left outer join
	コンピュータアドレス異動_T明細 as c2
	on c2.年度 = a2.年度
	and c2.[管理№] = a2.[管理№]
	and c2.IP1 = a2.IP1
	and c2.IP2 = a2.IP2
	and c2.IP3 = a2.IP3
	and c2.IP4 = a2.IP4
left outer join
	コンピュータ設置一覧_Q as d2
	on d2.[コンピュータ管理№] = c2.[コンピュータ管理№]
	and d2.ネットワーク数 = c2.ネットワーク数
left outer join
	社員_T as e2
	on e2.社員コード = d2.社員コード
)

select
	*

from
	v2 as a3

