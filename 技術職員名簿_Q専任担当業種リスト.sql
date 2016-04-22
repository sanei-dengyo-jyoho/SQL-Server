with

v0 as
(
select a01.*
from dbo.FuncTableEngineerWorkList(1) as a01
union all
select a02.*
from dbo.FuncTableEngineerWorkList(2) as a02
union all
select a03.*
from dbo.FuncTableEngineerWorkList(3) as a03
union all
select a04.*
from dbo.FuncTableEngineerWorkList(4) as a04
union all
select a05.*
from dbo.FuncTableEngineerWorkList(5) as a05
union all
select a06.*
from dbo.FuncTableEngineerWorkList(6) as a06
union all
select a07.*
from dbo.FuncTableEngineerWorkList(7) as a07
union all
select a08.*
from dbo.FuncTableEngineerWorkList(8) as a08
union all
select a09.*
from dbo.FuncTableEngineerWorkList(9) as a09
union all
select a10.*
from dbo.FuncTableEngineerWorkList(10) as a10

union all

select a11.*
from dbo.FuncTableEngineerWorkList(11) as a11
union all
select a12.*
from dbo.FuncTableEngineerWorkList(12) as a12
union all
select a13.*
from dbo.FuncTableEngineerWorkList(13) as a13
union all
select a14.*
from dbo.FuncTableEngineerWorkList(14) as a14
union all
select a15.*
from dbo.FuncTableEngineerWorkList(15) as a15
union all
select a16.*
from dbo.FuncTableEngineerWorkList(16) as a16
union all
select a17.*
from dbo.FuncTableEngineerWorkList(17) as a17
union all
select a18.*
from dbo.FuncTableEngineerWorkList(18) as a18
union all
select a19.*
from dbo.FuncTableEngineerWorkList(19) as a19
union all
select a20.*
from dbo.FuncTableEngineerWorkList(20) as a20

union all

select a21.*
from dbo.FuncTableEngineerWorkList(21) as a21
union all
select a22.*
from dbo.FuncTableEngineerWorkList(22) as a22
union all
select a23.*
from dbo.FuncTableEngineerWorkList(23) as a23
union all
select a24.*
from dbo.FuncTableEngineerWorkList(24) as a24
union all
select a25.*
from dbo.FuncTableEngineerWorkList(25) as a25
union all
select a26.*
from dbo.FuncTableEngineerWorkList(26) as a26
union all
select a27.*
from dbo.FuncTableEngineerWorkList(27) as a27
union all
select a28.*
from dbo.FuncTableEngineerWorkList(28) as a28
union all
select a29.*
from dbo.FuncTableEngineerWorkList(29) as a29
union all
select a30.*
from dbo.FuncTableEngineerWorkList(30) as a30
)
,

v1 as
(
SELECT
	a1.年度
,	a1.会社コード
,	a1.社員コード
,	a1.担当業種コード
,	b1.担当業種
,	b1.順位
FROM
	v0 AS a1
INNER JOIN
	担当業種_T AS b1
	ON b1.担当業種コード = a1.担当業種コード
)
,

v2 as
(
select distinct
	a2.年度 as 索引年度
,	a2.会社コード as 索引会社コード
,	a2.社員コード as 索引社員コード
,	dbo.FuncDeleteCharPrefix(l0.リスト,default) as 専任担当業種リスト
from
	技術職員名簿_T専任技術者 as a2
-- 複数行のカラムの値から、１つの区切りの文字列を生成 --
outer apply
	(
	select top 100 percent
		concat(N'、',b2.担当業種)
	from
		v1 as b2
	where
		( b2.年度 = a2.年度 )
		and ( b2.会社コード = a2.会社コード )
		and ( b2.社員コード = a2.社員コード )
	order by
		b2.順位
	for XML PATH ('')
	)
	as l0 (リスト)
)

select
	*
from
	v2 as v2000
