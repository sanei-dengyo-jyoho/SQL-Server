with

t0 as
(
select distinct
	a1.年度
,	a1.会社コード
,
	case
		isnull(ss.本部名,N'')
		when N'事業所'
		then 9
		else 1
	end
	as 本社
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
	運転許可証_Q車両種別 as p1
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
