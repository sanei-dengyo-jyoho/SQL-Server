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

v1 as
(
select
	会社コード
,	社員コード
,	資格種類
,	max(点数) as 点数
from
	v0 as a1
group by
	会社コード
,	社員コード
,	資格種類
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
	isnull(b2.資格名,'') +
	case
		when isnull(b2.交付番号,'') = ''
		then ' (' + isnull(b2.担当業種,'') + ')'
		else ''
	end +
	':::' +
	case
		when isnull(b2.取得日付,'') = ''
		then ''
		else convert(varchar(10),b2.取得日付,111)
	end +
	':::' +
	isnull(b2.交付番号,'') +
	':::' +
	isnull(b2.担当業種コード,'') +
	':::' +
	convert(varchar(10),isnull(b2.審査期間年,0)) +
	':::' +
	convert(varchar(10),isnull(b2.審査期間月,0))
	as 資格リスト
from
	v1 as a2
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
,
	convert(nvarchar(4000),
	replace(
			replace(
					replace(
							(
							select top 100 percent
								replace(
										replace(
												x10.資格リスト
												, N' ', N'@'
												)
										, N'　', N'＠'
										)
								as [data()]
							from
								v2 as x10
							where
								( x10.会社コード = v10.会社コード )
								and ( x10.社員コード = v10.社員コード )
							order by
								x10.点数 desc, x10.順位, x10.取得日付
							for XML PATH ('')
							)
							, N' ', N'、'
							)
					, N'@', N' '
					)
			, N'＠', N'　'
			)
	)
	as 資格区分リスト
from
	v2 as v10
)

select distinct
	*
from
	v3 as v300
