with

y0 as
(
select
	ya0.システム名
,	ya0.ページ
,	ya0.頁
,	ya0.行
,	ya0.大分類
,	ya0.中分類
,	ya0.小分類
,	ya0.費目
,	ya0.項目名
,
    case
        when isnull(ya0.費目,N'') = N''
        then 0
        else 1
    end
    as 項目名表示
,	ya0.[JV表示]
,	ya0.原価率表示
,	ya0.赤
,	ya0.緑
,	ya0.青
from
	工事原価項目_T小分類 as ya0
)
,

x4 as
(
SELECT
    xa4.システム名
,	xa4.ページ
,	xa4.頁
,	xb4.行
FROM
	(
	select
		xa3.システム名
	,	max(xa3.ページ) as ページ
	,	xa3.頁
	from
		y0 as xa3
	group by
		xa3.システム名
	,	xa3.頁
	)
	as xa4
outer apply
    (
    select
        x2.数値 as 行
    from
    	dbo.FuncViewConstConditionsInit(N'実行予算書の行数') as x2
	where
        ( x2.システム名 = xa4.システム名 )
    )
    as xb4
)
,

v4 as
(
select
	a4.システム名
,	isnull(b4.ページ,a4.ページ) as ページ
,	a4.頁
,
    a4.行 +
    case
        when isnull(b4.項目名,N'') = N''
        then 0
        else 1
    end
    as 行
,	a4.大分類
,	a4.中分類
,	999999 as 小分類
,	null as 費目
,	b4.項目名
,	b4.項目名表示
,	b4.[JV表示]
,	b4.原価率表示
,	b4.赤
,	b4.緑
,	b4.青
from
	(
	select
		a2.システム名
	,	max(a2.ページ) as ページ
	,	a2.頁
	,	max(a2.行) as 行
	,	a2.大分類
	,	a2.中分類
	from
		工事原価項目_T小分類 as a2
	group by
		a2.システム名
	,	a2.大分類
	,	a2.中分類
	,	a2.頁
	)
	as a4
left outer join
	(
	select
		a1.システム名
	,	a1.ページ
	,	a1.大分類
	,	a1.中分類
	,	a1.項目名
	,	1 as 項目名表示
	,	0 as [jv表示]
	,	a1.原価率表示
	,	a1.赤
	,	a1.緑
	,	a1.青
	from
		工事原価項目_T中分類 as a1
	where
		isnull(a1.項目名,N'') <> N''
	)
	as b4
	on b4.システム名 = a4.システム名
	and b4.大分類 = a4.大分類
	and b4.中分類 = a4.中分類
)
,

v6 as
(
select
	a6.システム名
,	isnull(b6.ページ,a6.ページ) as ページ
,	a6.頁
,
	a6.行 +
    case
        when isnull(b6.項目名,N'') = N''
        then 0
        else 1
    end
    as 行
,	a6.大分類
,	999999 as 中分類
,	999999 as 小分類
,	null as 費目
,	b6.項目名
,	b6.項目名表示
,	b6.[JV表示]
,	b6.原価率表示
,	b6.赤
,	b6.緑
,	b6.青
from
	(
	select
		a5.システム名
	,	max(a5.ページ) as ページ
	,	a5.頁
	,	max(a5.行) as 行
	,	a5.大分類
	from
		v4 as a5
	group by
		a5.システム名
	,	a5.大分類
	,	a5.頁
	)
	as a6
left outer join
	(
	select
		a0.システム名
	,	a0.ページ
	,	a0.大分類
	,	a0.項目名
	,	1 as 項目名表示
	,	0 as [jv表示]
	,	a0.原価率表示
	,	a0.赤
	,	a0.緑
	,	a0.青
	from
		工事原価項目_T大分類 as a0
	where
		isnull(a0.項目名,N'') <> N''
	)
	as b6
	on b6.システム名 = a6.システム名
	and b6.大分類 = a6.大分類
)
,

z0 as
(
select
	za0.システム名
,	max(za0.ページ) as ページ
,	max(za0.頁) as 頁
,	max(za0.行) as 行
,	999999 as 大分類
,	999999 as 中分類
,	999999 as 小分類
,	null as 費目
,	max(zb0.項目名) as 項目名
,	1 as 項目名表示
,	0 as [JV表示]
,	max(zb0.原価率表示) as 原価率表示
,	max(zb0.赤) as 赤
,	max(zb0.緑) as 緑
,	max(zb0.青) as 青
from
	x4 as za0
left outer join
    工事原価項目_T as zb0
	on zb0.システム名 = za0.システム名
group by
	za0.システム名
)
,

v9 as
(
select
	b9.システム名
,	a9.ページ
,	b9.頁
,	b9.行
,	a9.大分類
,	a9.中分類
,	a9.小分類
,	a9.費目
,	a9.項目名
,	null as 支払先1
,	null as 支払先2
,	null as 契約金額
,
	case
        when isnull(a9.費目,N'') = N''
        then 0
        else
            case
                when isnull(a9.項目名,N'') = N''
                then 1
                else 0
            end
    end
    as 項目名登録
,	isnull(a9.項目名表示,0) as 項目名表示
,	isnull(a9.[JV表示],0) as [JV表示]
,	isnull(a9.原価率表示,0) as 原価率表示
,	dbo.FuncMakePercentFormat(null,null) AS 原価率
,	a9.赤
,	a9.緑
,	a9.青
from
    x4 as b9
left outer join
	(
	select
	    c8.*
	from
		y0 as c8

	union all

	select
	    a8.*
	from
		v4 as a8
	where
		isnull(a8.項目名,N'') <> N''

	union all

	select
	    b8.*
	from
		v6 as b8
	where
		isnull(b8.項目名,N'') <> N''

	union all

	select
	    d8.*
	from
		z0 as d8
	)
	as a9
    on a9.システム名 = b9.システム名
	and a9.頁 = b9.頁
	and a9.行 = b9.行
)

select
	*
from
	v9 as v900
