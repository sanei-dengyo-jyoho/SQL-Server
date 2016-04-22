with

v1 as
(
select
    a1.工事年度
,	a1.工事種別
,	a1.工事項番
,	a1.共同企業体形成コード
,	isnull(b1.共同企業体形成名,N'') as 共同企業体形成名
,	isnull(b1.共同企業体形成名表示,N'') as 共同企業体形成名表示
,	a1.[JV]
,	a1.請負受注金額
,	a1.請負消費税率
,	a1.請負消費税額
,	a1.請負総額
,	dbo.FuncMakeMoneyFormat(a1.請負受注金額) as 請負税別受注額
,	dbo.FuncMakeMoneyFormat(a1.請負総額) as 請負税込受注額
,	dbo.FuncDeleteCharPrefix(l0.リスト,default) as [JV企業名]
,	dbo.FuncDeleteCharPrefix(l1.リスト,default) as [JV比率]
from
    (
    select
        a0.工事年度
    ,	a0.工事種別
    ,	a0.工事項番
    ,	max(a0.共同企業体形成コード) as 共同企業体形成コード
    ,	count(a0.工事項番) as [JV]
    ,	sum(a0.請負受注金額) as 請負受注金額
    ,	max(a0.請負消費税率) as 請負消費税率
    ,	sum(a0.請負消費税額) as 請負消費税額
    ,	isnull(sum(a0.請負受注金額),0) + isnull(sum(a0.請負消費税額),0) as 請負総額
    from
        (
        select
            ja0.工事年度
        ,	ja0.工事種別
        ,	ja0.工事項番
        ,	isnull(ja0.共同企業体形成コード,0) as 共同企業体形成コード
        ,	ja0.出資比率
        ,	ja0.企業名
        ,	ja0.請負受注金額
        ,	ja0.請負消費税率
        ,	ja0.請負消費税額
        from
            工事台帳_T共同企業体 as ja0
        )
        as a0
    group by
        a0.工事年度
    ,	a0.工事種別
    ,	a0.工事項番
    )
	as a1
left outer JOIN
    共同企業体形成コード_T as b1
    on b1.共同企業体形成コード = a1.共同企業体形成コード
-- 複数行のカラムの値から、１つの区切りの文字列を生成 --
outer apply
    (
    select top 100 percent
        concat(N'・',jv00.企業名)
    from
        (
        select
            jv000.工事年度
        ,	jv000.工事種別
        ,	jv000.工事項番
        ,	jv000.出資比率
        ,	jv000.企業名
        from
            工事台帳_T共同企業体 as jv000
        )
        as jv00
    where
        ( jv00.工事年度 = a1.工事年度 )
        and ( jv00.工事種別 = a1.工事種別 )
        and ( jv00.工事項番 = a1.工事項番 )
    order by
        jv00.工事年度
    ,	jv00.工事種別
    ,	jv00.工事項番
    ,	jv00.出資比率 DESC
    ,	jv00.企業名
    for XML PATH ('')
    )
    as l0 (リスト)
-- 複数行のカラムの値から、１つの区切りの文字列を生成 --
outer apply
    (
    select top 100 percent
        concat(N':',convert(nvarchar(8),jv01.出資比率))
    from
        (
        select
            jv010.工事年度
        ,	jv010.工事種別
        ,	jv010.工事項番
        ,	jv010.出資比率
        ,	jv010.企業名
        from
            工事台帳_T共同企業体 as jv010
        )
        as jv01
    where
        ( jv01.工事年度 = a1.工事年度 )
        and ( jv01.工事種別 = a1.工事種別 )
        and ( jv01.工事項番 = a1.工事項番 )
    order by
        jv01.工事年度
    ,	jv01.工事種別
    ,	jv01.工事項番
    ,	jv01.出資比率 DESC
    ,	jv01.企業名
    for XML PATH ('')
    )
    as l1 (リスト)
)
,

v3 as
(
select
    a3.*
,
    concat(
        case
            when isnull(a3.[JV出資比率],N'') <> N''
            then concat(a3.[JV出資比率],SPACE(1))
			else N''
        end,
        case
            when isnull(a3.請負税別受注額,N'') <> N''
            then
                concat(
                    CONVERT(nvarchar(50),a3.請負税別受注額),
                    N'（税別）'
                )
			else N''
        end
    )
    as 税別出資比率
,
    concat(
        case
            when isnull(a3.[JV出資比率詳細],N'') <> N''
            then concat(a3.[JV出資比率詳細],SPACE(1))
			else N''
        end,
        case
            when isnull(a3.請負税別受注額,N'') <> N''
            then
                concat(
                    N'契約金額',
                    SPACE(1),
                    CONVERT(nvarchar(50),a3.請負税別受注額),
                    N'（税別）'
                )
			else N''
        end
    )
    as 税別出資比率詳細
,
    concat(
        case
            when isnull(a3.[JV出資比率段落],N'') <> N''
            then concat(a3.[JV出資比率段落],CHAR(13),CHAR(10))
			else N''
        end,
        case
            when isnull(a3.請負税別受注額,N'') <> N''
            then
                concat(
                    CONVERT(nvarchar(50),a3.請負税別受注額),
                    N'（税別）'
                )
			else N''
        end
    )
    as 税別出資比率段落
,
    concat(
        case
            when isnull(a3.[JV出資比率詳細段落],N'') <> N''
            then concat(a3.[JV出資比率詳細段落],CHAR(13),CHAR(10))
			else N''
        end,
        case
            when isnull(a3.請負税別受注額,N'') <> N''
            then
                concat(
                    N'契約金額',
                    SPACE(1),
                    CONVERT(nvarchar(50),a3.請負税別受注額),
                    N'（税別）'
                )
			else N''
        end
    )
    as 税別出資比率詳細段落
,
    concat(
        case
            when isnull(a3.[JV出資比率],N'') <> N''
            then concat(a3.[JV出資比率],SPACE(1))
			else N''
        end,
        case
            when isnull(a3.請負税込受注額,N'') <> N''
            then
                concat(
                    CONVERT(nvarchar(50),a3.請負税込受注額),
                    N'（税込）'
                )
			else N''
        end
    )
    as 税込出資比率
,
    concat(
        case
            when isnull(a3.[JV出資比率詳細],N'') <> N''
            then concat(a3.[JV出資比率詳細],SPACE(1))
			else N''
        end,
        case
            when isnull(a3.請負税込受注額,N'') <> N''
            then
                concat(
                    N'契約金額',
                    SPACE(1),
                    CONVERT(nvarchar(50),a3.請負税込受注額),
                    N'（税込）'
                )
			else N''
        end
    )
    as 税込出資比率詳細
,
    concat(
        case
            when isnull(a3.[JV出資比率段落],N'') <> N''
            then concat(a3.[JV出資比率段落],CHAR(13),CHAR(10))
			else N''
        end,
        case
            when isnull(a3.請負税込受注額,N'') <> N''
            then
                concat(
                    CONVERT(nvarchar(50),a3.請負税込受注額),
                    N'（税込）'
                )
			else N''
        end
    )
    as 税込出資比率段落
,
    concat(
        case
            when isnull(a3.[JV出資比率詳細段落],N'') <> N''
            then concat(a3.[JV出資比率詳細段落],CHAR(13),CHAR(10))
			else N''
        end,
        case
            when isnull(a3.請負税込受注額,N'') <> N''
            then
                concat(
                    N'契約金額',
                    SPACE(1),
                    CONVERT(nvarchar(50),a3.請負税込受注額),
                    N'（税込）'
                )
			else N''
        end
    )
    as 税込出資比率詳細段落
from
	(
	select
	    a2.工事年度
	,	a2.工事種別
	,	a2.工事項番
	,	a2.共同企業体形成コード
	,	a2.共同企業体形成名
	,	a2.共同企業体形成名表示
	,	a2.[JV]
	,	a2.請負受注金額
	,	a2.請負消費税率
	,	a2.請負消費税額
	,	a2.請負総額
	,	a2.請負税別受注額
	,	a2.請負税込受注額
	,
	    concat(
	        case
	            when isnull(a2.[JV企業名],N'') <> N''
	            then
	                concat(
	                    N'（',
	                    a2.[JV企業名],
	                    a2.共同企業体形成名表示,
	                    N'JV）'
	                )
				else N''
	        end,
	        case
	            when isnull(a2.[JV比率],N'') <> N''
	            then concat(N'出資率',a2.[JV比率])
				else N''
	        end
	    )
	    as [JV出資比率]
	,
	    concat(
	        case
	            when isnull(a2.[JV企業名],N'') <> N''
	            then
	                concat(
	                    N'（',
	                    a2.[JV企業名],
	                    a2.共同企業体形成名表示,
	                    N'JV）',
	                    CHAR(13),CHAR(10)
	                )
				else N''
	        end,
	        case
	            when isnull(a2.[JV比率],N'') <> N''
	            then concat(N'出資率',a2.[JV比率])
				else N''
	        end
	    )
	    as [JV出資比率段落]
	,
	    concat(
	        case
	            when isnull(a2.[JV企業名],N'') <> N''
	            then
	                concat(
	                    N'（',
	                    a2.[JV企業名],
	                    a2.共同企業体形成名表示,
	                    N'建設共同企業体）'
	                )
				else N''
	        end,
	        case
	            when isnull(a2.[JV比率],N'') <> N''
	            then concat(N'出資率',a2.[JV比率])
				else N''
	        end
	    )
	    as [JV出資比率詳細]
	,
	    concat(
	        case
	            when isnull(a2.[JV企業名],N'') <> N''
	            then
	                concat(
	                    N'（',
	                    a2.[JV企業名],
	                    a2.共同企業体形成名表示,
	                    N'建設共同企業体）',
	                    CHAR(13),CHAR(10)
	                )
				else N''
	        end,
	        case
	            when isnull(a2.[JV比率],N'') <> N''
	            then concat(N'出資率',a2.[JV比率])
				else N''
	        end
	    )
	    as [JV出資比率詳細段落]
	from
		v1 as a2
	)
	as a3
)

SELECT
    *
FROM
    v3 AS v300
