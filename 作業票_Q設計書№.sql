with

v0 as
(
select
	'1' as 処理番号,
	年度,
	[管理№],
	[設計書№],
	支店コード,
	店所コード
from
	[作業票_T業務依頼書_設計書№]

union all

select
	'2' as 処理番号,
	年度,
	[管理№],
	[設計書№],
	支店コード,
	店所コード
from
	[作業票_T連絡票_設計書№]

union all

select
	'3' as 処理番号,
	年度,
	[管理№],
	[設計書№],
	支店コード,
	店所コード
from
	[作業票_Tヘルプコール_設計書№]
),

v1 as
(
select
	a1.処理番号,
	a1.年度,
	a1.[管理№],
	a1.[設計書№],
	a1.支店コード,
	b1.支店名,
	a1.店所コード,
	c1.店所名
from
	v0 as a1
left join
	東京電力支店コード_T as b1
	on b1.支店コード = a1.支店コード
left join
	東京電力店所コード_T as c1
	on c1.店所コード = a1.店所コード
)

select
	*
from
	v1 as v100

