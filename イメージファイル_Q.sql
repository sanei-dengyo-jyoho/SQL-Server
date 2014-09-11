SELECT
	u_filepath_name AS パス名
,	name AS ファイル名
,	file_stream AS ファイルストリーム
FROM
	FileTable_Qassets
WHERE
	( u_filepath_name LIKE '%\assets\Image\%.png%' )
