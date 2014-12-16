with

v0 as
(
select
	a0.会社コード
,	a0.社員コード
,	a0.[№]
,	a0.資格コード
,	b0.資格名
,	a0.交付番号
,	a0.取得日付
,	a0.取得年月日
,	isnull(c0.年度,year(isnull(a0.取得日付,'1960/02/01'))) as 年度
,	a0.担当業種コード
,	b0.担当業種入力
,	b0.審査期間年
,	b0.審査期間月

from
	工事技術者_T資格 as a0
left outer join
	資格_T as b0
	on b0.資格コード = a0.資格コード
left outer join
	カレンダ_T as c0
	on c0.日付 = a0.取得日付
)

select
	*

from
	v0 as v100
