WITH

v0 as
(
select DISTINCT
    convert(nvarchar(100),
        b.年号 +
        CONVERT(nvarchar(4),b.年) + N'年度'
    )
    AS 年集計
,   CONVERT(int,a.年度) AS 年
,   CONVERT(int,a.月) AS 月
,   CONVERT(int,a.年月) AS 年月
,   CONVERT(int,a.年度) AS 年度
,   a.[管理№] AS 番号
,
    CASE
        isnull(a.[管理№],'')
        WHEN ''
        THEN 0
        ELSE 1
    END
    AS 値
,
    convert(nvarchar(100),
        CASE
            ISNULL(a.日付,'')
            WHEN ''
            THEN ''
            ELSE format(cast(a.日付 as datetime),'d')
        END +
        CHAR(13)+CHAR(10) +
        case
            ISNULL(a.曜日,N'')
            when N''
            then N''
            else N'（' + ISNULL(a.曜日,N'') + N'）'
        end +
        ISNULL(a.時刻表示,N'')
    )
    as 発生日時
,   a.天候コード
,
    dbo.FuncGetSectionString(
        ISNULL(a.本部名,N''),
        ISNULL(a.部名,N''),
        ISNULL(a.部門名,N''),
        DEFAULT,
        CHAR(13)+CHAR(10)
    )
    as 所属
,
    convert(nvarchar(100),
        ISNULL(a.氏名,N'') +
        CASE
            ISNULL(a.協力会社名,N'')
            WHEN N''
            THEN N''
            ELSE N'（' + a.協力会社名 + N'）'
        END
    )
    as 氏名
,   ISNULL(a.性別,0) as 性別
,
    convert(nvarchar(100),
        ISNULL(a.年齢,N'') +
        CHAR(13)+CHAR(10) +
        ISNULL(a.経験,N'')
    )
    as [年齢／経験]
,   a.事故種別名 as 事故種別
,
    CASE
        ISNULL(a.事故種別,N'')
        WHEN '人'
        THEN 9
        ELSE 0
    END
    as 事故区分
,   a.同乗者の有無 as 同乗者
,   a.状況詳細 as 事故の概要
,
    convert(nvarchar(100),
        ISNULL(a.過失当社,N'') +
        CHAR(13)+CHAR(10) +
        ISNULL(a.過失相手,N'')
    )
    as 過失
,
    CASE
        ISNULL(a.事故処理報告書日付,'')
        WHEN ''
        THEN ''
        ELSE format(cast(a.事故処理報告書日付 as datetime),'d')
    END
    as 事故処理
,   a.原因
,   a.発生場所
from
    車両事故報告_Q as a
LEFT OUTER JOIN
    和暦_T as b
    on b.西暦=a.年度
)

SELECT
    *
FROM
    v0 as v000
