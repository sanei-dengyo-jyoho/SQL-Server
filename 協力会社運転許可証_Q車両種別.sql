with

v1 as
(
select
	p0.協力会社コード
,	p0.社員コード
,	p0.運転許可コード
,	b0.運転許可名
,	replace(
			replace(
					replace(
							(
							select
								replace(replace(bx.車両種別名, ' ', '@'), N'　', N'＠') as [data()]
							from
								協力会社運転許可証_T車両種別 as px
							inner join
								運転許可コード_T車両種別 as bx
								on bx.運転許可コード = px.運転許可コード
								and bx.車両種別 = px.車両種別
							where
								( px.協力会社コード = p0.協力会社コード )
								and ( px.社員コード = p0.社員コード )
								and ( px.運転許可コード = p0.運転許可コード )
							order by
								px.車両種別
							for XML PATH ('')
							)
							, ' ', N'、')
					, '@', ' ')
			, N'＠', N'　') as 車両種別選択
,	p0.発行日
,	p0.発行年度
,	p0.発行年月
,	p0.停止日
,	p0.停止年度
,	p0.停止年月

from
	協力会社運転許可証_T as p0
inner join
	運転許可コード_T as b0
	on b0.運転許可コード = p0.運転許可コード
)
,

v2 as
(
select
	協力会社コード
,	社員コード
,	運転許可コード
,	運転許可名
,	車両種別選択
,	replace(車両種別選択, N'、', N'、' + CHAR(13) + CHAR(10)) as 車両種別選択段落
,	発行日
,	発行年度
,	発行年月
,	停止日
,	停止年度
,	停止年月

from
	v1 as v100
)

select
	*

from
	v2 as v200
