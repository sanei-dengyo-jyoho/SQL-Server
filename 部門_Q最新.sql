with

v0 as
(
select distinct
	a0.新部門コード
,	a0.日付
,	a0.年度
,	b0.会社コード
,	b0.部門レベル
,	a0.部門コード
,	b0.上位コード
,	b0.所在地コード
,	b0.集計部門コード
,	b0.部門名
,	b0.部門名カナ
,	b0.部門名略称
,	b0.部門名省略
,	b0.集計先
,	b0.フロア
,	b0.内線番号
,	b0.登録区分
,	b0.更新日時
from
	(
	select
		q10.新部門コード
	,	q10.日付
	,	q10.年度
	,	q10.会社コード
	,	q10.部門レベル
	,	q10.部門コード
	,	q10.上位コード
	,	q10.所在地コード
	,	q10.コンピュータ設置部門コード
	,	q10.集計部門コード
	,	q10.部門名
	,	q10.部門名カナ
	,	q10.部門名略称
	,	q10.部門名省略
	,	q10.集計先
	,	q10.フロア
	,	q10.内線番号
	,	q10.登録区分
	,	q10.更新日時
	from
		部門_T異動 as q10
	inner join
		(
		select
			max(q00.日付) as 日付
		,	q00.部門コード
		from
			部門_T異動 as q00
		group by
			q00.部門コード
		)
		as q11
		on q11.部門コード = q10.部門コード
		and q11.日付 = q10.日付
	)
	as a0
inner join
	部門_T as b0
	on b0.部門コード = a0.新部門コード
)

select
	*
from
	v0 as v000
