with

v0 as
(
select
	*

from
	UserFileStreamDB.dbo.FileTable_Qdownload as a0

where
	( is_directory = '0' )
	and ( is_system = '0' )
)
,

v1 as
(
select
	u_rootpath_name
,	u_filepath_name
,	u_fullpath_name
,	stream_id
,	file_stream
,	name
,	path_locator
,	parent_path_locator
,	file_type
,	cached_file_size
,	creation_time
,	last_write_time
,	last_access_time
,	is_directory
,	is_offline
,	is_hidden
,	is_readonly
,	is_archive
,	is_system
,	is_temporary

from
	v0 as a1
)
,

v2 as
(
select
	convert(nvarchar(400),u_rootpath_name) as u_rootpath_name
,	convert(nvarchar(400),u_filepath_name) as u_filepath_name
,	convert(nvarchar(400),u_fullpath_name) as u_fullpath_name
,	stream_id
,	file_stream
,	name
,	path_locator
,	parent_path_locator
,	file_type
,	cached_file_size
,	creation_time
,	last_write_time
,	last_access_time
,	is_directory
,	is_offline
,	is_hidden
,	is_readonly
,	is_archive
,	is_system
,	is_temporary

from
	v1 as a2
)

select
	*

from
	v2 as a200
