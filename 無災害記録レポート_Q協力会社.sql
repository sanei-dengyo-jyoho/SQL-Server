with

v10 as
(
select distinct
	convert(int,a.年度) as 年度
,	convert(int,a.年) as 年
,	convert(int,a.月) as 月
,	convert(int,a.年月) as 年月
,	isnull(w0.年号,'') + dbo.FuncGetNumberFixed(isnull(w0.年,0), DEFAULT) + '年度' AS 和暦年度表示
,	isnull(w1.年号,'') + dbo.FuncGetNumberFixed(isnull(w1.年,0), DEFAULT) + '年' + dbo.FuncGetNumberFixed(a.月, DEFAULT) + '月' AS 和暦年月表示
,	'' as 会社
,	a.協力会社コード
,	isnull(v.協力会社名,isnull(a.協力会社名,'')) as 協力会社名
,	a.登録人員
,	a.当月
,	a.累計
,	case when isnull(a.起算日,'') = '' then '' else convert(varchar(10),a.起算日,111) end as 起算日
,	case when isnull(a.起算日,'') = '' then '' else '（ 起算日　' + convert(varchar(10),a.起算日,111) + ' ）' end as 起算日表示
,	case when isnull(a.起算日,'') = '' then '' else isnull(w2.年号,'') + dbo.FuncGetNumberFixed(isnull(w2.年,0), DEFAULT) + '年' + dbo.FuncGetNumberFixed(month(a.起算日), DEFAULT) + '月' + dbo.FuncGetNumberFixed(day(a.起算日), DEFAULT) + '日' end as 和暦起算日
,	case when isnull(a.起算日,'') = '' then '' else '（ 起算日　' + isnull(w2.年号,'') + dbo.FuncGetNumberFixed(isnull(w2.年,0), DEFAULT) + '年' + dbo.FuncGetNumberFixed(month(a.起算日), DEFAULT) + '月' + dbo.FuncGetNumberFixed(day(a.起算日), DEFAULT) + '日' + ' ）' end as 和暦起算日表示
,	a.備考

from
	無災害記録_T協力会社 as a
left outer join
	協力会社_T年度 as v
	on v.年度 = a.年度 
	and v.協力会社コード = a.協力会社コード
left outer join
	和暦_T as w0
	on w0.西暦 = a.年度
left outer join
	和暦_T as w1
	on w1.西暦 = a.年
left outer join
	和暦_T as w2
	on w2.西暦 = year(a.起算日)
)

select
	*

from
	v10 as v100

