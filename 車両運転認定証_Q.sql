with

v1 as
(
select
	p0.会社コード
,	p0.社員コード
,	p0.運転許可コード
,	b0.運転許可名
,	REPLACE((
			REPLACE((
					select TOP (100) PERCENT
						REPLACE(bx.車両種別名,'　','@') as [data()]

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

					FOR XML PATH ('')
					),' ','、')
			),'@','　') as 車両種別選択
,	p0.発行日
,	p0.発行年度
,	p0.発行年月
,	p0.停止日
,	p0.停止年度
,	p0.停止年月

from
	運転許可証_T as p0
inner join
	運転許可コード_T as b0
	on b0.運転許可コード = p0.運転許可コード
)
,

v2 as
(
select
	会社コード
,	社員コード
,	運転許可コード
,	運転許可名
,	車両種別選択
,	REPLACE(車両種別選択,'、','、'+CHAR(13)+CHAR(10)) as 車両種別選択段落
,	発行日
,	発行年度
,	発行年月
,	停止日
,	停止年度
,	停止年月

from
	v1 as v100
)
,

t0 as
(
select distinct
	a1.年度
,	a1.会社コード
,	case isnull(ss.本部名,'') when '事業所' then 9 else 1 end as 本社
,	ss.順序コード
,	ss.本部コード
,	ss.部コード
,	ss.課コード
,	ss.所在地コード
,	ss.部門レベル
,	ss.部門コード
,	ss.県コード
,	ss.本部名
,	ss.部名
,	ss.課名
,	ss.部門名
,	ss.場所名
,	ss.県名
,	ss.部門名カナ
,	ss.部門名略称
,	ss.部門名省略
,	cs.部門名階層段落 as 所属
,	cs.部門名階層 as 所属部署
,	a1.社員コード
,	a1.氏名
,	a1.氏
,	a1.名
,	a1.カナ氏名
,	a1.カナ氏
,	a1.カナ名
,	a1.読み順
,	a1.職制区分
,	a1.職制コード
,	a1.職制名
,	a1.職制名略称
,	a1.係コード
,	a1.係名
,	a1.係名省略
,	a1.生年月日
,	a1.年齢年月
,	a1.年齢年
,	a1.性別
,	a1.最終学歴
,	a1.出身校
,	a1.専攻
,	a1.入社日
,	a1.入社年度
,	a1.発令日
,	a1.退職日
,	a1.退職年度
,	a1.勤続年月
,	a1.勤続年
,	a1.年齢
,	a1.経験年数
,	a1.過去経験
,	a1.過去経験年
,	a1.過去経験月
,	a1.登録区分
,	p1.運転許可コード
,	p1.運転許可名
,	p1.発行日 as 運転許可日
,	p1.発行年度 as 運転許可年度
,	p1.発行年月 as 運転許可年月
,	p1.停止日 as 運転停止日
,	p1.停止年度 as 運転停止年度
,	p1.停止年月 as 運転停止年月
,	p1.車両種別選択 as 備考
,	p1.車両種別選択段落 as 車両種別

from
	社員_Q異動一覧 as a1
inner join
	部門_Q異動履歴_全階層順 as ss
	on ss.年度 = a1.年度
	and ss.会社コード = a1.会社コード
	and ss.部門コード = a1.部門コード
inner join
	部門_Q名称_階層順 AS cs
	on cs.年度 = a1.年度
	and cs.部門コード = a1.部門コード
inner join
	v2 as p1
	on p1.会社コード = a1.会社コード
	and p1.社員コード = a1.社員コード

where
	( isnull(a1.入社年度, 0) <= isnull(a1.年度, 0) )
	and ( isnull(a1.退職年度, 9999) > isnull(a1.年度, 0) )
	and ( isnull(p1.発行年度, 0) <= isnull(a1.年度, 0) )
	and ( isnull(p1.停止年度, 9999) > isnull(a1.年度, 0) )
)

select
	*

from
	t0 as t000

