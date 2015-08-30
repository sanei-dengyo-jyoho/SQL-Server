with

v1 as
(
SELECT
    b1.システム名
,   format(a1.工事年度,'D4') + a1.工事種別 + '-' + format(a1.工事項番,'D3') AS 工事番号
,   a1.工事年度
,   a1.工事種別
,   a1.工事項番
,   b1.工事種別名
,   b1.工事種別コード
,   a1.取引先コード
,   c1.取引先名
,   c1.取引先名カナ
,   c1.取引先略称
,   c1.取引先略称カナ
,   c1.得意先
,   a1.工事件名
,   a1.工事概要
,   a1.県コード
,   a1.市町村コード
,   a1.地区コード
,	g0.県名
,	g0.市区町村名
,   a1.工事場所
,   a1.予定工期自
,   a1.予定工期至
,   case
        when ISNULL(a1.予定工期自,'') <> '' and ISNULL(a1.予定工期至,'') <> ''
        then format(a1.予定工期自,'d') + N' ～ ' + format(a1.予定工期至,'d')
        when ISNULL(a1.予定工期自,'') <> '' and ISNULL(a1.予定工期至,'') = ''
        then format(a1.予定工期自,'d') + N' ～ '
        when ISNULL(a1.予定工期自,'') = '' and ISNULL(a1.予定工期至,'') <> ''
        then N' ～ ' + format(a1.予定工期至,'d')
        else N''
    end
    AS 予定工期
,   a1.実績工期自
,   a1.実績工期至
,   case
        when ISNULL(a1.実績工期自,'') <> '' and ISNULL(a1.実績工期至,'') <> ''
        then format(a1.実績工期自,'d') + N' ～ ' + format(a1.実績工期至,'d')
        when ISNULL(a1.実績工期自,'') <> '' and ISNULL(a1.実績工期至,'') = ''
        then format(a1.実績工期自,'d') + N' ～ '
        when ISNULL(a1.実績工期自,'') = '' and ISNULL(a1.実績工期至,'') <> ''
        then N' ～ ' + format(a1.実績工期至,'d')
        else N''
    end
    AS 実績工期
,   a1.受注日付
,   a1.着工日付
,   a1.竣工日付
,   a1.停止日付
,   case
        when isnull(a1.停止日付,'') <> ''
        then N'(停止)'
        when isnull(a1.竣工日付,'') <> ''
        then N'竣工'
        when isnull(a1.着工日付,'') <> ''
        then N'着工'
        when isnull(a1.受注日付,'') <> ''
        then N'受注'
        else N''
    end
    AS 処理結果
,   a1.受注金額
,   a1.消費税率
,   a1.消費税額
,   case
        when isnull(a1.停止日付,'') <> ''
        then a1.受注金額 * -1
        else a1.受注金額
    end
    as 受注金額表示
,   case
        when isnull(a1.停止日付,'') <> ''
        then a1.消費税額 * -1
        else a1.消費税額
    end
    as 消費税額表示
,   a1.担当会社コード
,   a1.担当部門コード
,   s1.部門名 AS 担当部門名
,   s1.部門名略称 AS 担当部門名略称
,   s1.集計部門コード
,   s2.部門名 AS 集計部門名
,   s2.部門名略称 AS 集計部門名略称
,   a1.担当社員コード
,   e1.氏名 AS 担当者名
FROM
    工事台帳_T AS a1
LEFT OUTER JOIN
    工事種別_T AS b1
    ON b1.工事種別 = a1.工事種別
LEFT OUTER JOIN
    発注先_Q AS c1
    ON c1.工事種別 = a1.工事種別
    AND c1.取引先コード = a1.取引先コード
LEFT OUTER JOIN
    部門_T年度 AS s1
    ON s1.年度 = a1.工事年度
    AND s1.会社コード = a1.担当会社コード
    AND s1.部門コード = a1.担当部門コード
LEFT OUTER JOIN
    部門_T年度 AS s2
    ON s2.年度 = s1.年度
    AND s2.会社コード = s1.会社コード
    AND s2.部門コード = s1.集計部門コード
LEFT OUTER JOIN
    社員_T年度 AS e1
    ON e1.年度 = a1.工事年度
    AND e1.会社コード = a1.担当会社コード
    AND e1.社員コード = a1.担当社員コード
LEFT OUTER JOIN
	市区町村_Q as g0
	ON g0.県コード = a1.県コード
	AND g0.市町村コード = a1.市町村コード
)
,

v2 as
(
SELECT
    a2.*
,   CASE
        WHEN ISNULL(a2.実績工期,N'') = N''
        THEN N'予定 ' + a2.予定工期
        ELSE N'実績 ' + a2.実績工期
    END
    AS 工期
,   b2.工事処理結果コード as 処理結果コード
FROM
    v1 AS a2
LEFT OUTER JOIN
    工事処理結果_T as b2
    on b2.工事処理結果 = a2.処理結果
)

SELECT
    *
FROM
    v2 as v200
