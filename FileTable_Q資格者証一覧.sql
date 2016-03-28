with

v0 as
(
select
	*
from
	FileTable_Q資格者証 as a0

where
	( name not like '%（講習受講）%' )
)
,

v2 as
(
select
	company_code
,	employee_code
,
	substring(name, charindex('(', name) + 1, 3)
	as qualify_code
,	u_rootpath_name
,	u_filepath_name
,	u_fullpath_name
,
	substring(u_fullpath_name, 1, charindex('.', u_fullpath_name) - 1) +
	'（講習受講）' +
	'.' +
	right(u_fullpath_name, charindex('.', reverse(u_fullpath_name)) - 1)
	as u_fullpath_name_exp
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
	v0 as a2
)

select
	*
from
	v2 as a200
