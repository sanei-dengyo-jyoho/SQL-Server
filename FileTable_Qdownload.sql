with

v2 as
(
select
	convert(nvarchar(400),a2.u_rootpath_name) as u_rootpath_name
,	convert(nvarchar(400),a2.u_filepath_name) as u_filepath_name
,	convert(nvarchar(400),a2.u_fullpath_name) as u_fullpath_name
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
		UserFileStreamDB.dbo.FileTable_Qdownload as a0
	where
		( a0.is_directory = '0' )
		and ( a0.is_system = '0' )
	)
	as a2
)

select
	*
from
	v2 as v200
