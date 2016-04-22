with

v0 as
(
select
	a0.会社コード
,	a0.社員コード
,	b0.資格コード
,	b0.資格名
,	b0.資格種類
,	b0.点数
,	a0.交付番号
,	a0.取得日付
,	a0.担当業種コード
,	c0.担当業種
,	b0.審査期間年
,	b0.審査期間月
,	b0.順位
from
	工事技術者_T資格 as a0
LEFT OUTER JOIN
	資格_T as b0
	on b0.資格コード = a0.資格コード
LEFT OUTER JOIN
	担当業種_T as c0
	on c0.担当業種コード = a0.担当業種コード
)
,

v2 as
(
select
	a2.会社コード
,	a2.社員コード
,	b2.資格名
,	a2.点数
,	b2.交付番号
,	b2.取得日付
,	b2.担当業種コード
,	b2.担当業種
,	b2.審査期間年
,	b2.審査期間月
,	b2.順位
,
	convert(nvarchar(4000),
		concat(
			isnull(b2.資格名,N''),
			case
				when isnull(b2.交付番号,'') = ''
				then concat(' (',isnull(b2.担当業種,''),')')
				else N''
			end,
			N':::',
			case
				when isnull(b2.取得日付,'') = ''
				then N''
				else convert(varchar(10),b2.取得日付,111)
			end,
			N':::',
			isnull(b2.交付番号,''),
			N':::',
			isnull(b2.担当業種コード,''),
			N':::',
			convert(varchar(10),isnull(b2.審査期間年,0)),
			N':::',
			convert(varchar(10),isnull(b2.審査期間月,0))
		)
	)
	as 資格リスト
from
	(
	select
		a1.会社コード
	,	a1.社員コード
	,	a1.資格種類
	,	max(a1.点数) as 点数
	from
		v0 as a1
	group by
		a1.会社コード
	,	a1.社員コード
	,	a1.資格種類
	)
	as a2
inner join
	v0 as b2
	on b2.会社コード = a2.会社コード
	and b2.社員コード = a2.社員コード
	and b2.資格種類 = a2.資格種類
	and b2.点数 = a2.点数
)
,

v3 as
(
select
	v10.会社コード as 索引会社コード
,	v10.社員コード as 索引社員コード
,	dbo.FuncDeleteCharPrefix(l0.リスト,default) as 資格区分リスト
from
	v2 as v10
-- 複数行のカラムの値から、１つの区切りの文字列を生成 --
outer apply
	(
	select top 100 percent
		concat(N'、',x10.資格リスト)
	from
		v2 as x10
	where
		( x10.会社コード = v10.会社コード )
		and ( x10.社員コード = v10.社員コード )
	order by
		x10.点数 desc
	,	x10.順位
	,	x10.取得日付
	for XML PATH ('')
	)
	as l0 (リスト)
)

select distinct
	*
from
	v3 as v300
