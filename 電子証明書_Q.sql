with

v0 as
(
select
	a0.[電子証明書№]
,	a0.媒体コード
,	b0.媒体名
,	b0.媒体名略称
,	a0.発行元
,	a0.名称
,	a0.番号
,	a0.ID
,	a0.パスワード
,	a0.有効期限自年度
,	a0.有効期限自年月
,	a0.有効期限自
,	a0.有効期限期間年
,	a0.有効期限至年度
,	a0.有効期限至年月
,	a0.有効期限至
,
	isnull(c0.氏名, '') +
	case
		when ( isnull(d0.部門名略称,N'') = N'' )
		 	and ( isnull(f0.職制名略称,N'') = N'' )
		then N''
		else
			concat(
				N'（',
				N'所属：',
				isnull(d0.部門名略称,N''),
				N'／',
				case
					when isnull(f0.職制名略称,N'') = N''
					then N''
					else f0.職制名略称
				end,
				case
					when isnull(g0.係名省略,N'') = N''
					then N''
					else concat(N'(',g0.係名省略m,N')')
				end,
				N'）'
			)
	end
	as 名義
,	a0.社員コード
,	c0.氏名
,	c0.カナ氏名
,	c0.部門コード
,	d0.部門名
,	d0.部門名略称
,	d0.部門名省略
,	c0.職制区分
,	e0.職制区分名
,	e0.職制区分名略称
,	c0.職制コード
,	f0.職制名
,	f0.職制名略称
,	c0.係コード
,	g0.係名
,	g0.係名略称
,	g0.係名省略
,	a0.登録日付
,	a0.登録区分
from
	電子証明書_T as a0
LEFT OUTER JOIN
	媒体_Q as b0
	on b0.媒体コード = a0.媒体コード
LEFT OUTER JOIN
	社員_T as c0
	on c0.社員コード = a0.社員コード
LEFT OUTER JOIN
	部門_T as d0
	on d0.部門コード = c0.部門コード
LEFT OUTER JOIN
	職制区分_T as e0
	on e0.職制区分 = c0.職制区分
LEFT OUTER JOIN
	職制_T as f0
	on f0.職制コード = c0.職制コード
LEFT OUTER JOIN
	係名_T as g0
	on g0.係コード = c0.係コード
)

select
	*
from
	v0 as a1
