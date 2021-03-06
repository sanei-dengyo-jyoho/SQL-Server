with

t0 as
(
select
	c1.年度
,	a1.キー
,	a1.グループ
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
,	a1.顔写真パス名
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
	協力会社運転許可証_Q車両種別 as p1
	on p1.協力会社コード = a1.協力会社コード
	and p1.社員コード = a1.社員コード
inner join
	(
	select
		a0.協力会社コード
	,	a0.年度
	from
		協力会社_T年度 as a0
	group by
		a0.協力会社コード
	,	a0.年度
	)
	as c1
	on c1.協力会社コード = a1.協力会社コード
where
	( isnull(a1.退職年度,9999) > isnull(c1.年度,0) )
	and ( isnull(p1.発行年度,0) <= isnull(c1.年度,0) )
	and ( isnull(p1.停止年度,9999) > isnull(c1.年度,0) )
)

select
	*
from
	t0 as t000
