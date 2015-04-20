with

t0 as
(
select
	max(年度) as 年度
,	部所グループコード

from
	部所グループ_T年度 as t00

group by
	部所グループコード
)
,

t1 as
(
select distinct
	t11.部所グループコード
,	t11.赤
,	t11.緑
,	t11.青
,	t11.色定数

from
	t0 as t10
LEFT OUTER JOIN
	部所グループ_T年度 as t11
	on t11.年度 = t10.年度
	and t11.部所グループコード = t10.部所グループコード
)
,

v0 as
(
select
	年度
,	年
,	月
,	年月
,	会社コード
,	部所グループコード
,	count(部所コード) as 部所件数

from
	無災害記録_T as q0

where
	( isnull(部所コード,0) <> 0 )

group by
	年度
,	年
,	月
,	年月
,	会社コード
,	部所グループコード
)
,

v10 as
(
select
	convert(int,a.年度) as 年度
,	convert(int,a.年) as 年
,	convert(int,a.月) as 月
,	convert(int,a.年月) as 年月
,	isnull(w0.年号,N'') + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(isnull(w0.年,0), DEFAULT)) + N'年度' AS 和暦年度表示
,	isnull(w1.年号,N'') + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(isnull(w1.年,0), DEFAULT)) + N'年' + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(a.月, DEFAULT)) + N'月' AS 和暦年月表示
,	a.会社コード
,	isnull(e.会社名,N'') as 会社名
,	'' as 全社
,	a.部所グループコード
,	a.部所コード
,	convert(int,isnull(b.部所件数,0)) as 部所件数
,	isnull(g.部所グループ名,isnull(a.部所グループ名,N'')) as 部所グループ名
,	isnull(s.部所名,isnull(a.部所名,N'')) as 部所名
,	a.人員
,	a.当月
,	a.累計 as 労働災害累計
,	case isnull(a.起算日,'') when '' then '' else convert(varchar(10),a.起算日,111) end as 労働災害起算日
,	case isnull(a.起算日,'') when '' then N'' else N'（ 起算日　' + convert(nvarchar(10),a.起算日,111) + N' ）' end as 労働災害起算日表示
,	case isnull(a.起算日,'') when '' then N'' else isnull(w2.年号,N'') + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(isnull(w2.年,0), DEFAULT)) + N'年' + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(month(a.起算日), DEFAULT)) + N'月' + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(day(a.起算日), DEFAULT)) + N'日' end as 労働災害和暦起算日
,	case isnull(a.起算日,'') when '' then N'' else N'（ 起算日　' + isnull(w2.年号,N'') + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(isnull(w2.年,0), DEFAULT)) + N'年' + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(month(a.起算日), DEFAULT)) + N'月' + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(day(a.起算日), DEFAULT)) + N'日' + N' ）' end as 労働災害和暦起算日表示
,	convert(int,isnull(g.赤,isnull(h.赤,255))) as 赤
,	convert(int,isnull(g.緑,isnull(h.緑,255))) as 緑
,	convert(int,isnull(g.青,isnull(h.青,255))) as 青
,	isnull(g.色定数,isnull(h.色定数,'#FFFFFF')) as 色定数
,	isnull(a.備考,'') as 労働災害備考
,	v.累計 as 交通事故累計
,	case isnull(v.起算日,'') when '' then '' else convert(varchar(10),v.起算日,111) end as 交通事故起算日
,	case isnull(v.起算日,'') when '' then N'' else N'（ 起算日　' + convert(nvarchar(10),v.起算日,111) + N' ）' end as 交通事故起算日表示
,	case isnull(v.起算日,'') when '' then N'' else isnull(w3.年号,N'') + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(isnull(w3.年,0), DEFAULT)) + N'年' + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(month(v.起算日), DEFAULT)) + N'月' + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(day(v.起算日), DEFAULT)) + N'日' end as 交通事故和暦起算日
,	case isnull(v.起算日,'') when '' then N'' else N'（ 起算日　' + isnull(w3.年号,N'') + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(isnull(w3.年,0), DEFAULT)) + N'年' + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(month(v.起算日), DEFAULT)) + N'月' + CONVERT(nvarchar(20), dbo.FuncGetNumberFixed(day(v.起算日), DEFAULT)) + N'日' + N' ）' end as 交通事故和暦起算日表示
,	isnull(v.備考,N'') as 交通事故備考

from
	無災害記録_T as a
LEFT OUTER JOIN
	無事故記録_T as v
	on v.年度 = a.年度
	and v.年 = a.年
	and v.月 = a.月
	and v.年月 = a.年月
	and v.会社コード = a.会社コード
	and v.部所グループコード = a.部所グループコード
	and v.部所コード = a.部所コード
LEFT OUTER JOIN
	v0 as b
	on b.年度 = a.年度
	and b.年 = a.年
	and b.月 = a.月
	and b.年月 = a.年月
	and b.会社コード = a.会社コード
	and b.部所グループコード = a.部所グループコード
LEFT OUTER JOIN
	部所グループ_T年度 as g
	on g.年度 = a.年度 
	and g.部所グループコード = a.部所グループコード
LEFT OUTER JOIN
	t1 as h
	on h.部所グループコード = a.部所グループコード 
LEFT OUTER JOIN
	部所_T年度 as s
	on s.年度 = a.年度
	and s.部所グループコード = a.部所グループコード
	and s.部所コード = a.部所コード
LEFT OUTER JOIN
	会社_T as e
	on e.会社コード = a.会社コード
LEFT OUTER JOIN
	和暦_T as w0
	on w0.西暦 = a.年度
LEFT OUTER JOIN
	和暦_T as w1
	on w1.西暦 = a.年
LEFT OUTER JOIN
	和暦_T as w2
	on w2.西暦 = year(a.起算日)
LEFT OUTER JOIN
	和暦_T as w3
	on w3.西暦 = year(v.起算日)
)

select
	*

from v10
	as v100

