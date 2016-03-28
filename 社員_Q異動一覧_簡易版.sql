with

v1 as
(
select
	a1.年度
,	a1.会社コード
,	a1.社員コード
,	a1.氏名
,	a1.氏
,	a1.名
,	a1.カナ氏名
,	a1.カナ氏
,	a1.カナ名
,	a1.読み順
,	f1.県コード
,	b1.所在地コード
,	b1.集計部門コード
,	b1.部門レベル
,	b1.上位コード
,	a1.部門コード
,	b1.部門名
,	b1.部門名略称
,	b1.部門名省略
,	a1.職制区分
,	a1.職制コード
,	e1.職制名
,	e1.職制名略称
,	a1.係コード
,	d1.係名
,	d1.係名省略
,	a1.生年月日
,
	dbo.FuncGetAgeString(
		isnull(a1.生年月日,''),
		GETDATE(),
		N'才',
		DEFAULT
	)
	as 年齢年月
,
	dbo.FuncGetAgeString(
		isnull(a1.生年月日,''),
		GETDATE(),
		N'',
		N'N'
	)
	as 年齢年
,	isnull(a1.性別,1) as 性別
,	isnull(a1.最終学歴,6) as 最終学歴
,	a1.出身校
,	a1.専攻
,	a1.入社日
,	c1.年度 as 入社年度
,	a1.発令日
,	a1.退職日
,	a1.退職年度
,
	dbo.FuncGetAgeString(
		isnull(a1.入社日,''),
		isnull(a1.退職日,GETDATE()),
		DEFAULT,
		DEFAULT
	)
	as 勤続年月
,
	dbo.FuncGetAgeString(
		isnull(a1.入社日,''),
		isnull(a1.退職日,GETDATE()),
		N'',
		N'N'
	)
	as 勤続年
,	a1.内線番号
,	a1.メールアドレス
,	a1.郵便番号
,	a1.住所
,	a1.建物名
,	a1.TEL
,	a1.FAX
,	a1.緊急連絡先
,	a1.登録区分
,	a1.更新日時
from
	社員_T年度 as a1
left join
	部門_T年度 as b1
	on b1.年度 = a1.年度
	and b1.部門コード = a1.部門コード
left join
	カレンダ_T as c1
	on c1.日付 = a1.入社日
left join
	係名_T as d1
	on d1.係コード = a1.係コード
left join
	職制_T as e1
	on e1.職制区分 = a1.職制区分
	and e1.職制コード = a1.職制コード
left join
	会社住所_T年度 as f1
	on f1.年度 = b1.年度
	and f1.所在地コード = b1.所在地コード
)

select
	*
from
	v1 as v100
