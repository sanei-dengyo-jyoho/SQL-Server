with

v0 as
(
select
	a0.年度
,	a0.会社コード
,	a0.社員コード
,	e0.氏名
,	e0.カナ氏名
,	x0.県コード
,	s0.所在地コード
,	z0.部門コード as 集計部門コード
,	z0.部門コード
,	z0.部門名
,	z0.部門名略称
,	z0.部門名省略
,	e0.職制区分
,	e0.職制コード
,	y0.職制名
,
	dbo.FuncGetPositionString(
		isnull(y0.職制名略称,''),
		isnull(w0.係名省略,''),
		default,
		default
	)
	as 職制名略称
,	e0.出身校
,	e0.専攻
,	e0.性別
,	e0.生年月日
,	e0.入社日
,	e0.退職日
,	e0.退職年度
,	a0.資格区分
,	a0.表示資格名1
,	a0.表示資格名2
,	a0.表示資格名3
,	a0.表示資格名4
,	a0.表示資格名5
,	a0.交付番号1
,	a0.交付番号2
,	a0.交付番号3
,	a0.交付番号4
,	a0.交付番号5
,	a0.取得日付1
,	a0.取得日付2
,	a0.取得日付3
,	a0.取得日付4
,	a0.取得日付5
,	a0.担当業種コード1
,	a0.担当業種コード2
,	b0.担当業種名 as 担当業種名1
,	c0.担当業種名 as 担当業種名2
,	b0.担当業種 as 担当業種1
,	c0.担当業種 as 担当業種2
,	a0.交付番号
,	a0.交付日付
,	a0.講習受講
,	a0.年齢
,	a0.経験年数
,	a01.[№] as 監理技術者
,	a02.[№] as 専任技術者
,	a03.[№] as 使用人
,	a04.[№] as 主任電気工事士
,	a0.頁
,	a0.行
,	a0.枝番
from
	技術職員名簿_T明細 as a0
LEFT OUTER JOIN
	技術職員名簿_T監理技術者 as a01
	on a01.会社コード = a0.会社コード
	and a01.年度 = a0.年度
	and a01.社員コード = a0.社員コード
LEFT OUTER JOIN
	技術職員名簿_T専任技術者 as a02
	on a02.会社コード = a0.会社コード
	and a02.年度 = a0.年度
	and a02.社員コード = a0.社員コード
LEFT OUTER JOIN
	技術職員名簿_T使用人 as a03
	on a03.会社コード = a0.会社コード
	and a03.年度 = a0.年度
	and a03.社員コード = a0.社員コード
LEFT OUTER JOIN
	技術職員名簿_T主任電気工事士 as a04
	on a04.会社コード = a0.会社コード
	and a04.年度 = a0.年度
	and a04.社員コード = a0.社員コード
LEFT OUTER JOIN
	担当業種_T as b0
	on b0.担当業種コード = a0.担当業種コード1
LEFT OUTER JOIN
	担当業種_T as c0
	on c0.担当業種コード = a0.担当業種コード2
LEFT OUTER JOIN
	社員_T年度 as e0
	on e0.会社コード = a0.会社コード
	and e0.年度 = a0.年度
	and e0.社員コード = a0.社員コード
LEFT OUTER JOIN
	職制_T as y0
	on y0.職制区分 = e0.職制区分
	and y0.職制コード = e0.職制コード
LEFT OUTER JOIN
	係名_T as w0
	on w0.係コード = e0.係コード
LEFT OUTER JOIN
	部門_T年度 as s0
	on s0.会社コード = e0.会社コード
	and s0.年度 = e0.年度
	and s0.部門コード = e0.部門コード
LEFT OUTER JOIN
	部門_T年度 as z0
	on z0.会社コード = s0.会社コード
	and z0.年度 = s0.年度
	and z0.部門コード = s0.集計部門コード
LEFT OUTER JOIN
	会社住所_T as x0
	on x0.会社コード = s0.会社コード
	and x0.所在地コード = s0.所在地コード
where
	( isnull(a0.頁,'') <> '' )
	and ( isnull(a0.行,'') <> '' )
	and ( isnull(a0.枝番,'') <> '' )
	and ( isnull(a0.社員コード,'') <> '' )
)

select
	*
from
	v0 as a1
