with

v2 as
(
select
	a2.company_code
,	a2.employee_code
,
	convert(nvarchar(4000),
		substring(a2.name,charindex('(',a2.name)+1,3)
	)
	as qualify_code
,	a2.u_rootpath_name
,	a2.u_filepath_name
,	a2.u_fullpath_name
,
	convert(nvarchar(4000),
		substring(a2.u_fullpath_name,1,charindex('.',a2.u_fullpath_name)-1) +
		N'（講習受講）' +
		N'.' +
		right(a2.u_fullpath_name,charindex('.',reverse(a2.u_fullpath_name))-1)
	)
	as u_fullpath_name_exp
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
		a0.*
	from
		FileTable_Q資格者証 as a0
	where
		( a0.name not like '%（講習受講）%' )
	)
	as a2
)

select
	*
from
	v2 as v200
