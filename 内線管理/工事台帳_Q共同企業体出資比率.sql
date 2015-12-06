with

v0 as
(
select
    工事年度
,   工事種別
,   工事項番
,   count(工事項番) as [JV]
,   sum(請負受注金額) as 請負受注金額
,   max(請負消費税率) as 請負消費税率
,   sum(請負消費税額) as 請負消費税額
,   isnull(sum(請負受注金額),0) + isnull(sum(請負消費税額),0) as 請負総額
from
    工事台帳_T共同企業体 as a0
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
,   a1.[JV]
,   case
        when isnull(a1.[JV],0) = 0
        then N''
        else convert(nvarchar(10),a1.[JV]) + N'社JV'
    end
    as [JV企業数]
,   a1.請負受注金額
,   a1.請負消費税率
,   a1.請負消費税額
,	a1.請負総額
,   dbo.FuncMakeMoneyFormat(a1.請負受注金額) as 請負税別受注額
,   dbo.FuncMakeMoneyFormat(a1.請負総額) as 請負税込受注額
,   replace(
            replace(
                    replace(
                            (
                            select
                                replace(replace(jv0.企業名, ' ', '@'), N'　', N'＠')+':'+convert(varchar(8),jv0.出資比率)+'%' AS [data()]
                            from
                                工事台帳_T共同企業体 as jv0
                            where
                                ( jv0.工事年度 = a1.工事年度 )
                                and ( jv0.工事種別 = a1.工事種別 )
                                and ( jv0.工事項番 = a1.工事項番 )
                            order by
                                jv0.工事年度
                            ,    jv0.工事種別
                            ,    jv0.工事項番
                            ,    jv0.出資比率 DESC
                            ,    jv0.企業名
                            for XML PATH ('')
                            )
                            , ' ', N'、')
                    , '@', ' ')
            , N'＠', N'　') AS [JV出資比率]
,	replace(
            replace(
                    replace(
                            (
                            select
                                replace(replace(jv1.企業名, ' ', '@'), N'　', N'＠')+':'+convert(varchar(8),jv1.出資比率)+'%' AS [data()]
                            from
                                工事台帳_T共同企業体 as jv1
                            where
                                ( jv1.工事年度 = a1.工事年度 )
                                and ( jv1.工事種別 = a1.工事種別 )
                                and ( jv1.工事項番 = a1.工事項番 )
                            order by
                                jv1.工事年度
                            ,    jv1.工事種別
                            ,    jv1.工事項番
                            ,    jv1.出資比率 DESC
                            ,    jv1.企業名
                            for XML PATH ('')
                            )
                            , ' ', N'、'+CHAR(13)+CHAR(10))
                    , '@', ' ')
            , N'＠', N'　') AS [JV出資比率段落]
from
	v0 as a1
)
,

v2 as
(
select
    工事年度
,   工事種別
,   工事項番
,   [JV]
,   [JV企業数]
,   請負受注金額
,   請負消費税率
,   請負消費税額
,	請負総額
,   請負税別受注額
,   請負税込受注額
,   CONVERT(nvarchar(400),[JV出資比率]) AS [JV出資比率]
,   CONVERT(nvarchar(400),[JV出資比率段落]) AS [JV出資比率段落]
,   case
        when isnull([JV企業数],N'') = N''
        then N''
        else CONVERT(nvarchar(50),[JV企業数])
    end
    +
    case
        when isnull([JV出資比率],N'') = N''
        then N''
        else SPACE(3)+CONVERT(nvarchar(400),[JV出資比率])
    end
    +
    case
        when isnull(請負税別受注額,N'') = N''
        then N''
        else SPACE(3)+CONVERT(nvarchar(50),請負税別受注額) + N'（税別）'
    end
    as 税別出資比率
,   case
        when isnull([JV企業数],N'') = N''
        then N''
        else CONVERT(nvarchar(50),[JV企業数])
    end
    +
    case
        when isnull([JV出資比率],N'') = N''
        then N''
        else SPACE(3)+CONVERT(nvarchar(400),[JV出資比率])
    end
    +
    case
        when isnull(請負税別受注額,N'') = N''
        then N''
        else CHAR(13)+CHAR(10)+SPACE(3)+CONVERT(nvarchar(50),請負税別受注額) + N'（税別）'
    end
    as 税別出資比率段落
,   case
        when isnull([JV企業数],N'') = N''
        then N''
        else CONVERT(nvarchar(50),[JV企業数])
    end
    +
    case
        when isnull([JV出資比率],N'') = N''
        then N''
        else SPACE(3)+CONVERT(nvarchar(400),[JV出資比率])
    end
    +
    case
        when isnull(請負税込受注額,N'') = N''
        then N''
        else SPACE(3)+CONVERT(nvarchar(50),請負税込受注額) + N'（税込）'
    end
    as 税込出資比率
,   case
        when isnull([JV企業数],N'') = N''
        then N''
        else CONVERT(nvarchar(50),[JV企業数])
    end
    +
    case
        when isnull([JV出資比率],N'') = N''
        then N''
        else SPACE(3)+CONVERT(nvarchar(400),[JV出資比率])
    end
    +
    case
        when isnull(請負税込受注額,N'') = N''
        then N''
        else CHAR(13)+CHAR(10)+SPACE(3)+CONVERT(nvarchar(50),請負税込受注額) + N'（税込）'
    end
    as 税込出資比率段落
from
	v1 as a2
)

SELECT
    *
FROM
    v2 AS v200
