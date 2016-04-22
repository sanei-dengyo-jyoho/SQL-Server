with

v10 as
(
select
	convert(int,a.年度) as 年度
,	convert(int,a.年) as 年
,	convert(int,a.月) as 月
,	convert(int,a.年月) as 年月
,
	convert(nvarchar(100),
		isnull(w0.年号,N'') +
		format(isnull(w0.年,0),'D2') + N'年度'
	)
	AS 和暦年度表示
,
	convert(nvarchar(100),
		isnull(w1.年号,N'') +
		format(isnull(w1.年,0),'D2') + N'年' +
		format(a.月,'D2') + N'月'
	)
	AS 和暦年月表示
,	a.会社コード
,	isnull(e.会社名,N'') as 会社名
,	N'' as 全社
,	a.部所グループコード
,	a.部所コード
,	a.部所グループ名
,	a.部所名
,	isnull(a.赤,255) as 赤
,	isnull(a.緑,255) as 緑
,	isnull(a.青,255) as 青
,	isnull(a.色定数,'#FFFFFF') as 色定数
,	a.人数 as 人員
,	isnull(a.部所件数,0) as 部所件数
	------------
	-- 労働災害 --
	------------
,	a.労働災害当月 as 当月
,	a.労働災害累計
,
	case
		isnull(a.労働災害起算日,'')
		when ''
		then ''
		else format(a.労働災害起算日,'d')
	end
	as 労働災害起算日
,
	case
		isnull(a.労働災害起算日,'')
		when ''
		then N''
		else
			convert(nvarchar(100),
				N'（' +
				N'起算日' +
				space(1) +
				format(a.労働災害起算日,'d') +
				N'）'
			)
	end
	as 労働災害起算日表示
,
	case
		isnull(a.労働災害起算日,'')
		when ''
		then N''
		else
			convert(nvarchar(100),
				isnull(w2.年号,N'') +
				format(isnull(w2.年,0),'D2') + N'年' +
				format(month(a.労働災害起算日),'D2') + N'月' +
				format(day(a.労働災害起算日),'D2') + N'日'
			)
	end
	as 労働災害和暦起算日
,
	case
		isnull(a.労働災害起算日,'')
		when ''
		then N''
		else
			convert(nvarchar(100),
				N'（' +
				N'起算日' +
				space(1) +
				isnull(w2.年号,N'') +
				format(isnull(w2.年,0),'D2') + N'年' +
				format(month(a.労働災害起算日),'D2') + N'月' +
				format(day(a.労働災害起算日),'D2') + N'日' +
				N'）'
			)
	end
	as 労働災害和暦起算日表示
--,	a.労働災害備考--
,	N'' as 労働災害備考
	------------
	-- 交通事故 --
	------------
,	a.車両事故累計 as 交通事故累計
,
	case
		isnull(a.車両事故起算日,'')
		when ''
		then ''
		else format(a.車両事故起算日,'d')
	end
	as 交通事故起算日
,
	case
		isnull(a.車両事故起算日,'')
		when ''
		then N''
		else
			convert(nvarchar(100),
				N'（' +
				N'起算日' +
				space(1) +
				format(a.車両事故起算日,'d') +
				N'）'
			)
	end
	as 交通事故起算日表示
,
	case
		isnull(a.車両事故起算日,'')
		when ''
		then N''
		else
			convert(nvarchar(100),
				isnull(w3.年号,N'') +
				format(isnull(w3.年,0),'D2') + N'年' +
				format(month(a.車両事故起算日),'D2') + N'月' +
				format(day(a.車両事故起算日),'D2') + N'日'
			)
	end
	as 交通事故和暦起算日
,
	case
		isnull(a.車両事故起算日,'')
		when ''
		then N''
		else
			convert(nvarchar(100),
				N'（' +
				N'起算日' +
				space(1) +
				isnull(w3.年号,N'') +
				format(isnull(w3.年,0),'D2') + N'年' +
				format(month(a.車両事故起算日),'D2') + N'月' +
				format(day(a.車両事故起算日),'D2') + N'日' +
				N'）'
			)
	end
	as 交通事故和暦起算日表示
--,	a.車両事故備考 as 交通事故備考--
,	N'' as 交通事故備考
from
	無事故無災害記録_Q as a
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
	on w2.西暦 = year(a.労働災害起算日)
LEFT OUTER JOIN
	和暦_T as w3
	on w3.西暦 = year(a.車両事故起算日)
)

select
	*
from
	v10 as v100
