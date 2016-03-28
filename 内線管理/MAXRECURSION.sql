use UserDB
go

select
	*
from
	工事進捗レポート_Q

OPTION
	(
	MAXRECURSION 0
,	FORCE ORDER
	);
go
