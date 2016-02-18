USE [UserDB]
GO

Declare @create_limit datetime
-- 6ヶ月以上前に作成されたインデックスが対象
SELECT
	@create_limit = DATEADD(MONTH, -6, GETDATE())

SELECT
	OBJECT_SCHEMA_NAME(i.[object_id]) as [Shema Name]
,	OBJECT_NAME(i.[object_id]) AS [Table Name]
,	i.name as [Index Name]
,	o.create_date
,	o.modify_date
FROM
	sys.indexes AS i
INNER JOIN
	sys.objects AS o
	ON i.[object_id] = o.[object_id]
WHERE
	i.index_id NOT IN
		(
		SELECT
			s.index_id
		FROM
			sys.dm_db_index_usage_stats AS s
		WHERE
			s.[object_id] = i.[object_id]
			AND i.index_id = s.index_id
		)
	AND o.[type] = 'U'
	-- Primary Key を除外
	AND i.is_primary_key != 1
	-- Unique Key を除外
	AND i.is_unique_constraint != 1
	AND i.name is not null
	AND o.create_date < @create_limit
	-- 対象外のスキーマを除外
	AND OBJECT_SCHEMA_NAME(i.[object_id]) not in ('capsim')
ORDER BY
	OBJECT_SCHEMA_NAME(i.[object_id])
,	OBJECT_NAME(i.[object_id])
,	create_date

GO
