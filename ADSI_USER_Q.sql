with

v0 as
(
select
	convert(nvarchar(50),sAMAccountName) as ユーザ名
,	convert(nvarchar(50),substring(sAMAccountName,6,len(sAMAccountName)-5)) as 社員コード
from
	ADSI_PERSON_Q as a0
where
	( sAMAccountName like N'sed-s%' )
)

select
	*
from
	v0 as v000
