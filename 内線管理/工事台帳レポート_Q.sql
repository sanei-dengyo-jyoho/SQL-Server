with

v0 AS
(
SELECT
    b0.システム名
,   dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,   a0.工事年度
,   a0.工事種別
,   a0.工事項番
,   b0.工事種別名
,   b0.工事種別コード
,   c0.発注先種別名
,   a0.取引先コード
,   c0.取引先名
,   c0.取引先名カナ
,   c0.取引先略称
,   c0.取引先略称カナ
,   c0.得意先
,   a0.取引先担当
,   a0.工事件名
,   a0.工事概要
,   a0.県コード
,   a0.市町村コード
,   a0.地区コード
,	g0.県名
,	g0.市区町村名
,   a0.工事場所
,   a0.工期自日付
,   a0.工期至日付
,   dbo.FuncMakeConstructPeriod(a0.工期自日付,a0.工期至日付,DEFAULT) AS 工期
,   ISNULL(d1.和暦日付,N'') + N' ～ ' + ISNULL(d2.和暦日付,N'') AS 和暦工期
,   a0.受注日付
,   a0.着工日付
,   a0.竣工日付
,   a0.停止日付
,   dbo.FuncMakeConstructStatus(a0.受注日付,a0.着工日付,a0.竣工日付,a0.停止日付) AS 処理結果
,   a0.受注金額
,   a0.消費税率
,   a0.消費税額
,
   case
        when isnull(a0.停止日付,'') <> ''
        then a0.受注金額 * -1
        else a0.受注金額
    end
    as 受注金額表示
,
   case
        when isnull(a0.停止日付,'') <> ''
        then a0.消費税額 * -1
        else a0.消費税額
    end
    as 消費税額表示
,   j0.[JV]
,   j0.[JV出資比率]
,   j0.[JV出資比率段落]
,   j0.[JV出資比率詳細]
,   j0.[JV出資比率詳細段落]
,   isnull(j0.請負受注金額,a0.受注金額) AS 請負受注金額
,   isnull(j0.請負消費税率,a0.消費税率) AS 請負消費税率
,   isnull(j0.請負消費税額,a0.消費税額) AS 請負消費税額
,   isnull(j0.請負受注金額,a0.受注金額) + isnull(j0.請負消費税額,a0.消費税額) AS 請負総額
,
   case
        when isnull(a0.停止日付,'') <> ''
        then isnull(j0.請負受注金額,a0.受注金額) * -1
        else isnull(j0.請負受注金額,a0.受注金額)
    end
    as 請負受注金額表示
,
   case
        when isnull(a0.停止日付,'') <> ''
        then isnull(j0.請負消費税額,a0.消費税額) * -1
        else isnull(j0.請負消費税額,a0.消費税額)
    end
    as 請負消費税額表示
,   a0.担当会社コード
,   a0.担当部門コード
,   s0.部門名 AS 担当部門名
,   s0.部門名略称 AS 担当部門名略称
,   s0.集計部門コード
,   s1.部門名 AS 集計部門名
,   s1.部門名略称 AS 集計部門名略称
,   a0.担当社員コード
,   e0.氏名 AS 担当者名
FROM
    工事台帳_T AS a0
LEFT OUTER JOIN
    工事種別_T AS b0
    ON b0.工事種別 = a0.工事種別
LEFT OUTER JOIN
    工事台帳_Q共同企業体出資比率 AS j0
    ON j0.工事年度 = a0.工事年度
    AND j0.工事種別 = a0.工事種別
    AND j0.工事項番 = a0.工事項番
LEFT OUTER JOIN
    発注先_Q AS c0
    ON c0.工事種別 = a0.工事種別
    AND c0.取引先コード = a0.取引先コード
LEFT OUTER JOIN
    部門_T年度 AS s0
    ON s0.年度 = a0.工事年度
    AND s0.会社コード = a0.担当会社コード
    AND s0.部門コード = a0.担当部門コード
LEFT OUTER JOIN
    部門_T年度 AS s1
    ON s1.年度 = s0.年度
    AND s1.会社コード = s0.会社コード
    AND s1.部門コード = s0.集計部門コード
LEFT OUTER JOIN
    社員_T年度 AS e0
    ON e0.年度 = a0.工事年度
    AND e0.会社コード = a0.担当会社コード
    AND e0.社員コード = a0.担当社員コード
LEFT OUTER JOIN
	市区町村_Q as g0
	ON g0.県コード = a0.県コード
	AND g0.市町村コード = a0.市町村コード
LEFT OUTER JOIN
    カレンダ_Q AS d1
    ON d1.日付 = a0.工期自日付
LEFT OUTER JOIN
    カレンダ_Q AS d2
    ON d2.日付 = a0.工期至日付
)
,

v1 as
(
SELECT
    a1.*
,
    format(a1.請負総額,'c') +
    N'　（税込）' + space(8) +
    convert(nvarchar(5),a1.消費税率) +
    N'%'
    as 請負税込受注額
,
    format(a1.請負受注金額,'c') +
    N'　（税別）'
    as 請負税別受注額
,   b1.工事処理結果コード as 処理結果コード
,   b1.工事処理結果表示 as 処理結果表示
FROM
    v0 AS a1
LEFT OUTER JOIN
    工事処理結果_T as b1
    on b1.工事処理結果 = a1.処理結果
)

SELECT
    *
FROM
    v1 as v100
