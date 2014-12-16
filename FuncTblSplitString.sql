-------------------------------------------------------------------------------
-- Split関数
-------------------------------------------------------------------------------
-- 開始位置と終了位置を返すselect文をcteで
-- 初期のアンカーメンバーを1と最初の区切り文字の場所として
-- 区切り文字+1と次の区切り文字を区切り文字がなくなるまで再帰する。
-- 上記の結果、できたクエリでsubstringする。
-------------------------------------------------------------------------------
CREATE FUNCTION dbo.FuncTblSplitString(@str nvarchar(max), @sep nvarchar(max))
RETURNS TABLE
AS
RETURN
	WITH
	a AS
	(
	SELECT
		CAST(0 AS BIGINT) AS idx1
	,	CHARINDEX(@sep, @str) AS idx2
	UNION ALL
	SELECT
		idx2 + 1
	,	CHARINDEX(@sep, @str, idx2 + 1)
	FROM
		a
	WHERE
		(idx2 > 0)
	)
	SELECT
		SUBSTRING(@str, idx1, COALESCE(NULLIF(idx2, 0), LEN(@str) + 1) - idx1) AS value
	FROM
		a
