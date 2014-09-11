with

v1 as
(
select
	p0.協力会社コード
,	p0.社員コード
,	p0.運転許可コード
,	b0.運転許可名
,	REPLACE((
			REPLACE((
					select TOP (100) PERCENT
						REPLACE(bx.車両種別名,'　','@') as [data()]

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

v0 as
(
select
	協力会社コード
,	年度

from
	協力会社_T年度 as a0

group by
	協力会社コード
,	年度
)
,

t0 as
(
select
	c1.年度
,	a1.協力会社コード
,	a1.協力会社名
,	a1.社員コード
,	a1.氏名
,	a1.氏
,	a1.名
,	a1.カナ氏名
,	a1.カナ氏
,	a1.カナ名
,	a1.読み順
,	a1.生年月日
,	a1.年齢年月
,	a1.年齢年
,	a1.性別
,	a1.最終学歴
,	a1.入社日
,	a1.入社年度
,	a1.経験年月
,	a1.経験年
,	a1.経験月
,	a1.発令日
,	a1.退職日
,	a1.退職年度
,	a1.勤続年月
,	a1.勤続年
,	a1.部署名
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
	協力会社社員_Q as a1
inner join
	v2 as p1
	on p1.協力会社コード = a1.協力会社コード
	and p1.社員コード = a1.社員コード
inner join
	v0 as c1
	on c1.協力会社コード = a1.協力会社コード

where
	( isnull(a1.退職年度, 9999) > isnull(c1.年度, 0) )
	and ( isnull(p1.発行年度, 0) <= isnull(c1.年度, 0) )
	and ( isnull(p1.停止年度, 9999) > isnull(c1.年度, 0) )
)

select
	*

from
	t0 as t000

