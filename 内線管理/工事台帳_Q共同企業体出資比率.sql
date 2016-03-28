with

j0 as
(
select
    工事年度
,   工事種別
,   工事項番
,   isnull(共同企業体形成コード,0) as 共同企業体形成コード
,   出資比率
,   企業名
,   請負受注金額
,   請負消費税率
,   請負消費税額
from
    工事台帳_T共同企業体 as ja0
)
,

v0 as
(
select
    工事年度
,   工事種別
,   工事項番
,   max(共同企業体形成コード) as 共同企業体形成コード
,   count(工事項番) as [JV]
,   sum(請負受注金額) as 請負受注金額
,   max(請負消費税率) as 請負消費税率
,   sum(請負消費税額) as 請負消費税額
,   isnull(sum(請負受注金額),0) + isnull(sum(請負消費税額),0) as 請負総額
from
    j0 as a0
group by
    工事年度
,   工事種別
,   工事項番
)
,

v1 as
(
select
    a1.工事年度
,   a1.工事種別
,   a1.工事項番
,   a1.共同企業体形成コード
,   isnull(b1.共同企業体形成名,N'') as 共同企業体形成名
,   isnull(b1.共同企業体形成名表示,N'') as 共同企業体形成名表示
,   a1.[JV]
,   a1.請負受注金額
,   a1.請負消費税率
,   a1.請負消費税額
,	a1.請負総額
,   dbo.FuncMakeMoneyFormat(a1.請負受注金額) as 請負税別受注額
,   dbo.FuncMakeMoneyFormat(a1.請負総額) as 請負税込受注額
,	dbo.FuncDeleteCharPrefix(l0.リスト,default) as [JV企業名]
,	dbo.FuncDeleteCharPrefix(l1.リスト,default) as [JV比率]
from
	v0 as a1
left outer JOIN
    共同企業体形成コード_T as b1
    on b1.共同企業体形成コード = a1.共同企業体形成コード
/*　複数行のカラムの値から、１つの区切りの文字列を生成　*/
outer apply
    (
    select top 100 percent
        N'・' +
        jv00.企業名
    from
        j0 as jv00
    where
        ( jv00.工事年度 = a1.工事年度 )
        and ( jv00.工事種別 = a1.工事種別 )
        and ( jv00.工事項番 = a1.工事項番 )
    order by
        jv00.工事年度
    ,   jv00.工事種別
    ,   jv00.工事項番
    ,   jv00.出資比率 DESC
    ,   jv00.企業名
    for XML PATH ('')
    )
    as l0 (リスト)
/*　複数行のカラムの値から、１つの区切りの文字列を生成　*/
outer apply
    (
    select top 100 percent
        N':' +
        convert(nvarchar(8),jv01.出資比率)
    from
        j0 as jv01
    where
        ( jv01.工事年度 = a1.工事年度 )
        and ( jv01.工事種別 = a1.工事種別 )
        and ( jv01.工事項番 = a1.工事項番 )
    order by
        jv01.工事年度
    ,   jv01.工事種別
    ,   jv01.工事項番
    ,   jv01.出資比率 DESC
    ,   jv01.企業名
    for XML PATH ('')
    )
    as l1 (リスト)
)
,

v2 as
(
select
    工事年度
,   工事種別
,   工事項番
,   共同企業体形成コード
,   共同企業体形成名
,   共同企業体形成名表示
,   [JV]
,   請負受注金額
,   請負消費税率
,   請負消費税額
,	請負総額
,   請負税別受注額
,   請負税込受注額
,
    convert(nvarchar(4000),
        case
            when isnull([JV企業名],N'') = N''
            then N''
            else
                N'（' +
                [JV企業名] +
                共同企業体形成名表示 +
                N'JV）'
        end
        +
        case
            when isnull([JV比率],N'') = N''
            then N''
            else
                N'出資率' +
                [JV比率]
        end
    )
    as [JV出資比率]
,
    convert(nvarchar(4000),
        case
            when isnull([JV企業名],N'') = N''
            then N''
            else
                N'（' +
                [JV企業名] +
                共同企業体形成名表示 +
                N'JV）' +
                CHAR(13)+CHAR(10)
        end
        +
        case
            when isnull([JV比率],N'') = N''
            then N''
            else
                N'出資率' +
                [JV比率]
        end
    )
    as [JV出資比率段落]
,
    convert(nvarchar(4000),
        case
            when isnull([JV企業名],N'') = N''
            then N''
            else
                N'（' +
                [JV企業名] +
                共同企業体形成名表示 +
                N'建設共同企業体）'
        end
        +
        case
            when isnull([JV比率],N'') = N''
            then N''
            else
                N'出資率' +
                [JV比率]
        end
    )
    as [JV出資比率詳細]
,
    convert(nvarchar(4000),
        case
            when isnull([JV企業名],N'') = N''
            then N''
            else
                N'（' +
                [JV企業名] +
                共同企業体形成名表示 +
                N'建設共同企業体）' +
                CHAR(13)+CHAR(10)
        end
        +
        case
            when isnull([JV比率],N'') = N''
            then N''
            else
                N'出資率' +
                [JV比率]
        end
    )
    as [JV出資比率詳細段落]
from
	v1 as a2
)
,

v3 as
(
select
    工事年度
,   工事種別
,   工事項番
,   共同企業体形成コード
,   共同企業体形成名
,   共同企業体形成名表示
,   [JV]
,   請負受注金額
,   請負消費税率
,   請負消費税額
,	請負総額
,   請負税別受注額
,   請負税込受注額
,   [JV出資比率]
,   [JV出資比率段落]
,   [JV出資比率詳細]
,   [JV出資比率詳細段落]
,
    convert(nvarchar(4000),
        case
            when isnull([JV出資比率],N'') = N''
            then N''
            else
                [JV出資比率] +
                SPACE(1)
        end
        +
        case
            when isnull(請負税別受注額,N'') = N''
            then N''
            else
                CONVERT(nvarchar(50),請負税別受注額) +
                N'（税別）'
        end
    )
    as 税別出資比率
,
    convert(nvarchar(4000),
        case
            when isnull([JV出資比率詳細],N'') = N''
            then N''
            else
                [JV出資比率詳細] +
                SPACE(1)
        end
        +
        case
            when isnull(請負税別受注額,N'') = N''
            then N''
            else
                N'契約金額' +
                SPACE(1) +
                CONVERT(nvarchar(50),請負税別受注額) +
                N'（税別）'
        end
    )
    as 税別出資比率詳細
,
    convert(nvarchar(4000),
        case
            when isnull([JV出資比率段落],N'') = N''
            then N''
            else
                [JV出資比率段落] +
                CHAR(13)+CHAR(10)
        end
        +
        case
            when isnull(請負税別受注額,N'') = N''
            then N''
            else
                CONVERT(nvarchar(50),請負税別受注額) +
                N'（税別）'
        end
    )
    as 税別出資比率段落
,
    convert(nvarchar(4000),
        case
            when isnull([JV出資比率詳細段落],N'') = N''
            then N''
            else
                [JV出資比率詳細段落] +
                CHAR(13)+CHAR(10)
        end
        +
        case
            when isnull(請負税別受注額,N'') = N''
            then N''
            else
                N'契約金額' +
                SPACE(1) +
                CONVERT(nvarchar(50),請負税別受注額) +
                N'（税別）'
        end
    )
    as 税別出資比率詳細段落
,
    convert(nvarchar(4000),
        case
            when isnull([JV出資比率],N'') = N''
            then N''
            else
                [JV出資比率] +
                SPACE(1)
        end
        +
        case
            when isnull(請負税込受注額,N'') = N''
            then N''
            else
                CONVERT(nvarchar(50),請負税込受注額) +
                N'（税込）'
        end
    )
    as 税込出資比率
,
    convert(nvarchar(4000),
        case
            when isnull([JV出資比率詳細],N'') = N''
            then N''
            else
                [JV出資比率詳細] +
                SPACE(1)
        end
        +
        case
            when isnull(請負税込受注額,N'') = N''
            then N''
            else
                N'契約金額' +
                SPACE(1) +
                CONVERT(nvarchar(50),請負税込受注額) +
                N'（税込）'
        end
    )
    as 税込出資比率詳細
,
    convert(nvarchar(4000),
        case
            when isnull([JV出資比率段落],N'') = N''
            then N''
            else
                [JV出資比率段落] +
                CHAR(13)+CHAR(10)
        end
        +
        case
            when isnull(請負税込受注額,N'') = N''
            then N''
            else
                CONVERT(nvarchar(50),請負税込受注額) +
                N'（税込）'
        end
    )
    as 税込出資比率段落
,
    convert(nvarchar(4000),
        case
            when isnull([JV出資比率詳細段落],N'') = N''
            then N''
            else
                [JV出資比率詳細段落] +
                CHAR(13)+CHAR(10)
        end
        +
        case
            when isnull(請負税込受注額,N'') = N''
            then N''
            else
                N'契約金額' +
                SPACE(1) +
                CONVERT(nvarchar(50),請負税込受注額) +
                N'（税込）'
        end
    )
    as 税込出資比率詳細段落
from
	v2 as a3
)

SELECT
    *
FROM
    v3 AS v300
