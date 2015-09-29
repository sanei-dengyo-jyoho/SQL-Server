SELECT
    A.システム名
,   CONVERT(int, ROW_NUMBER() OVER(ORDER BY A.職制区分, A.職制コード)) AS 項番
,   A.職制区分
,   A.職制コード
,   ISNULL(A.標題, B.職制名略称) AS 標題
FROM
    捺印_T AS A
LEFT OUTER JOIN
    職制_T AS B
    ON B.職制区分 = A.職制区分
    AND B.職制コード = A.職制コード
