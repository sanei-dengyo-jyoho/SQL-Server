with

v10 as
(
select distinct
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
,	'' as 会社
,	a.協力会社コード
,	a.協力会社名
,	a.人数 as 登録人員
,
	case
		when a.協力会社コード <> 0
		then a.労働災害当月
	end
	as 当月
,
	case
		when a.協力会社コード <> 0
		then a.労働災害累計
	end
	as 累計
,
	case
		when a.協力会社コード <> 0
		then
			case
				when isnull(a.労働災害起算日,'') = ''
				then N''
				else format(a.労働災害起算日,'d')
			end
	end
	as 起算日
,
	case
		when a.協力会社コード <> 0
		then
			case
				when isnull(a.労働災害起算日,'') = ''
				then N''
				else
				 	convert(nvarchar(100),
						N'（' +
						space(1) +
						N'起算日' +
						space(1) +
						format(a.労働災害起算日,'d') +
						space(1) +
						N'）'
					)
			end
	end
	as 起算日表示
,
	case
		when a.協力会社コード <> 0
		then
			case
				when isnull(a.労働災害起算日,'') = ''
				then N''
				else
					convert(nvarchar(100),
						isnull(w2.年号,N'') +
						format(isnull(w2.年,0),'D2') + N'年' +
						format(month(a.労働災害起算日),'D2') + N'月' +
						format(day(a.労働災害起算日),'D2') + N'日'
					)
			end
	end
	as 和暦起算日
,
	case
		when a.協力会社コード <> 0
		then
			case
				when isnull(a.労働災害起算日,'') = ''
				then N''
				else
					convert(nvarchar(100),
						N'（' +
						space(1) +
						N'起算日' +
						space(1) +
						isnull(w2.年号,N'') +
						format(isnull(w2.年,0),'D2') + N'年' +
						format(month(a.労働災害起算日),'D2') + N'月' +
						format(day(a.労働災害起算日),'D2') + N'日' +
						space(1) +
						N'）'
					)
			end
	end
	as 和暦起算日表示
--,	a.労働災害備考 as 備考--
,	N'' as 備考
from
	無災害記録_Q協力会社 as a
LEFT OUTER JOIN
	和暦_T as w0
	on w0.西暦 = a.年度
LEFT OUTER JOIN
	和暦_T as w1
	on w1.西暦 = a.年
LEFT OUTER JOIN
	和暦_T as w2
	on w2.西暦 = year(a.労働災害起算日)
)

select
	*
from
	v10 as v100
