with

v0 as
(
select
	convert(nvarchar(50),sAMAccountName) as ユーザ名
,	convert(int, substring(sAMAccountName,6,len(sAMAccountName)-5)) as 社員コード

from
	ADSI_PERSON_Q as a0

where
	( sAMAccountName like 'sed-s%' )
)

select
	*

from
	v0 as a1

