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
,

v21 as
(
select
	company_code
,	employee_code
,	max(creation_time) as creation_time
from
	v2 as a21
group by
	company_code
,	employee_code
)
,

v22 as
(
select
	a22.company_code
,	a22.employee_code
,	convert(nvarchar(400),a22.u_rootpath_name) as u_rootpath_name
,	convert(nvarchar(400),a22.u_filepath_name) as u_filepath_name
,	convert(nvarchar(400),a22.u_fullpath_name) as u_fullpath_name
,	a22.stream_id
,	a22.file_stream
,	a22.name
,	a22.path_locator
,	a22.parent_path_locator
,	a22.file_type
,	a22.cached_file_size
,	a22.creation_time
,	a22.last_write_time
,	a22.last_access_time
,	a22.is_directory
,	a22.is_offline
,	a22.is_hidden
,	a22.is_readonly
,	a22.is_archive
,	a22.is_system
,	a22.is_temporary

from
	v2 as a22
inner join
	v21 as b22
	on b22.company_code = a22.company_code
	and b22.employee_code = a22.employee_code
	and b22.creation_time = a22.creation_time
)

select
	*

from
	v22 as a200
