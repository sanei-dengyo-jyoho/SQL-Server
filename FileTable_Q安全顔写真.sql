with

v0 as
(
select
	*

from
	UserFileStreamDB.dbo.FileTable_Q安全顔写真 as a0

where
	( is_directory = '0' )
	and ( is_system = '0' )
)
,

v1 as
(
select
	'10' as company_code
,	substring(name, 1, 4) as employee_code
,	u_rootpath_name
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
	company_code
,	case when isnumeric(employee_code) = 1 then convert(int,employee_code) else 0 end as employee_code
,	u_rootpath_name
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
	v1 as a2
)

select
	*

from
	v2 as a200
