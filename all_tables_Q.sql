WITH

v0 AS
(
SELECT
	t.name
,	t.object_id
,	t.principal_id
,	t.schema_id
,	t.parent_object_id
,	t.type
,	t.type_desc
,	t.create_date
,	t.modify_date
,	t.is_ms_shipped
,	t.is_published
,	t.is_schema_published
,	p.in_row_data_page_count
,	p.row_count
FROM
	sys.objects AS t
INNER JOIN
	sys.dm_db_partition_stats AS p
	ON t.object_id = p.object_id
WHERE
	(t.type = 'U')
)

SELECT
	*
FROM
	v0 AS v000
