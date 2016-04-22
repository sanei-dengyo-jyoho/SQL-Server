WITH

VX AS
(
SELECT
	I.is_unique AS [is_unique]
,	I.type_desc AS [index_type]
,	I.index_id AS [index_id]
,	I.name AS [index_name]
,	Schema_name(T.Schema_id) AS [schema_name]
,	T.Object_id AS [table_id]
,	T.name AS [table_name]
,	KeyColumns AS [key_columns]
,	IncludedColumns AS [included_columns]
,	I.Filter_definition AS [filter_definition]
,	I.is_padded AS [pad_index]
,	I.Fill_factor AS [fill_factor]
,	I.ignore_dup_key AS [ignore_dup_key]
,	ST.no_recompute AS [no_recompute]
,	I.allow_row_locks [allow_row_locks]
,	I.allow_page_locks AS [allow_page_locks]
,	ST.auto_created AS [auto_created]
,	I.is_primary_key AS [is_primary_key]
,	I.is_unique_constraint AS [is_unique_constraint]
,	I.is_disabled AS [is_disabled]
,	I.Is_hypothetical AS [is_hypothetical]
,	I.has_filter AS [has_filter]
,	DS.name AS [file_group_name]
,	indexstats.avg_fragmentation_in_percent AS [avg_fragmentation_in_percent]
FROM
	sys.indexes AS I
JOIN
	sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
	ON I.object_id = indexstats.object_id
	AND I.index_id = indexstats.index_id
JOIN
	sys.tables AS T
	ON I.Object_id = T.Object_id
JOIN
	sys.sysindexes AS SI
	ON I.Object_id = SI.id
	AND I.index_id = SI.indid
JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			IC2.object_id
		,	IC2.index_id
		,
			STUFF(
					(
					SELECT
						' , ' +
						C.name +
						CASE
							WHEN MAX(CONVERT(INT,IC1.is_descending_key)) = 1
							THEN ' DESC '
							ELSE ' ASC '
						END
					FROM
						sys.index_columns AS IC1
					INNER JOIN
						Sys.columns AS C
						ON C.object_id = IC1.object_id
						AND C.column_id = IC1.column_id
						AND IC1.is_included_column = 0
					WHERE IC1.object_id = IC2.object_id
						AND IC1.index_id = IC2.index_id
					GROUP BY
						IC1.object_id,C.name,index_id
					ORDER BY
						MAX(IC1.key_ordinal)
					FOR XML PATH('')
					)
			, 1, 2, ''
			)
			AS KeyColumns
		FROM
			sys.index_columns AS IC2
		GROUP BY
			IC2.object_id
		,	IC2.index_id
		) AS tmp3
	) AS tmp4
	ON I.object_id = tmp4.object_id
	AND I.Index_id = tmp4.index_id
JOIN
	sys.stats AS ST
	ON ST.object_id = I.object_id
	AND ST.stats_id = I.index_id
JOIN
	sys.data_spaces AS DS
	ON I.data_space_id = DS.data_space_id
LEFT OUTER JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT
			IC2.object_id
		,	IC2.index_id
		,
			STUFF(
					(
					SELECT
						' , ' +
						C.name
					FROM
						sys.index_columns AS IC1
					JOIN
						Sys.columns C
						ON C.object_id = IC1.object_id
						AND C.column_id = IC1.column_id
						AND IC1.is_included_column = 1
					WHERE
						IC1.object_id = IC2.object_id
						AND IC1.index_id = IC2.index_id
					GROUP BY
						IC1.object_id,C.name,index_id
					FOR XML PATH('')
					)
			, 1, 2, ''
			)
			AS IncludedColumns
		FROM
			sys.index_columns AS IC2
		GROUP BY
			IC2.object_id
		,	IC2.index_id
		) AS tmp1
	WHERE
		IncludedColumns IS NOT NULL
	) AS tmp2
	ON tmp2.object_id = I.object_id
	AND tmp2.index_id = I.index_id
)

SELECT
	*
FROM
	VX AS VX00
