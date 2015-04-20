with

v0 as
(
select distinct
	a0.年度
,	a0.[管理№]
,	isnull(a0.確定済,0) as 確定済
,	a0.ドメイン名
,	b0.IP1
,	b0.IP2
,	b0.IP3
,	b0.IP4
,	dbo.FuncMakeComputerIPAddress(isnull(b0.IP1,0),isnull(b0.IP2,0),isnull(b0.IP3,0),isnull(b0.IP4,0),DEFAULT) as IPアドレス
,	b0.[コンピュータ管理№]
,	b0.ネットワーク数
,	isnull(b0.[コンピュータ管理№],'') + '(' + convert(varchar(4),isnull(b0.ネットワーク数,0)) + ')' as [コンピュータ管理№数]
,	b0.設置日
,	b0.旧IP1
,	b0.旧IP2
,	b0.旧IP3
,	b0.旧IP4
,	dbo.FuncMakeComputerIPAddress(isnull(b0.旧IP1,0),isnull(b0.旧IP2,0),isnull(b0.旧IP3,0),isnull(b0.旧IP4,0),DEFAULT) as 旧IPアドレス
,	c0.[コンピュータ分類№]
,	c0.コンピュータ分類
,	c0.[コンピュータタイプ№]
,	c0.コンピュータタイプ識別
,	c0.コンピュータタイプ
,	c0.機器名
,	c0.メーカ名
,	c0.会社コード
,	c0.集計部門コード
,	c0.設置部門コード
,	c0.部門コード
,	c0.部門名略称
,	c0.社員コード
,	e0.氏名
,	e0.カナ氏名
,	e0.性別
,	case when isnull(e0.社員コード,0) = 0 then -2 else isnull(e0.登録区分,-1) end as 社員登録区分
,	c0.備考
,	c0.利用

from
	コンピュータアドレス異動_T as a0
left join
	コンピュータアドレス異動_T明細 as b0
	on b0.年度 = a0.年度
	and b0.[管理№] = a0.[管理№]
left join
	コンピュータ設置一覧_Q as c0
	on c0.[コンピュータ管理№] = b0.[コンピュータ管理№]
	and c0.ネットワーク数 = b0.ネットワーク数
LEFT OUTER JOIN
	社員_T年度 as e0
	on e0.年度 = b0.年度
	and e0.社員コード = c0.社員コード
)

select
	*

from
	v0 as a1

