with

v2 as
(
select
	case
		when isnumeric(a2.company_code) = 1
		then convert(int,a2.company_code)
		else 0
	end
	as company_code
,
	case
		when isnumeric(a2.employee_code) = 1
		then convert(int,a2.employee_code)
		else 0
	end
	as employee_code
,	a2.u_rootpath_name
,	a2.u_filepath_name
,	a2.u_fullpath_name
,	a2.stream_id
,	a2.file_stream
,	a2.name
,	a2.path_locator
,	a2.parent_path_locator
,	a2.file_type
,	a2.cached_file_size
,	a2.creation_time
,	a2.last_write_time
,	a2.last_access_time
,	a2.is_directory
,	a2.is_offline
,	a2.is_hidden
,	a2.is_readonly
,	a2.is_archive
,	a2.is_system
,	a2.is_temporary
from
	(
	select
		reverse(
			substring(reverse(a0.[u_filepath_name]),
			patindex('%[\]%', reverse(a0.[u_filepath_name])) + 1, 4)
		)
		as company_code
	,
		substring(a0.name, 1, 4)
		as employee_code
	,	a0.*
	from
		UserFileStreamDB.dbo.FileTable_Q協力会社顔写真 as a0
	where
		( a0.is_directory = '0' )
		and ( a0.is_system = '0' )
	)
	as a2
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
	(
	select
		a21.company_code
	,	a21.employee_code
	,	max(a21.creation_time) as creation_time
	from
		v2 as a21
	group by
		a21.company_code
	,	a21.employee_code
	)
	as b22
	on b22.company_code = a22.company_code
	and b22.employee_code = a22.employee_code
	and b22.creation_time = a22.creation_time
)

select
	*
from
	v22 as v2200
