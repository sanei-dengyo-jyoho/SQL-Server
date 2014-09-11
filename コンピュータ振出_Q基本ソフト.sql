with

v0 as
(
select
	基本ソフト分類
,	基本ソフト名
,	[コンピュータ管理№]
,	ネットワーク数
,	isnull([コンピュータ管理№],'') + '(' + convert(varchar(4),isnull(ネットワーク数,0)) + ')' as [コンピュータ管理№数]
from
	コンピュータ振出_T基本ソフト as a0
)

select
	*
from
	v0 as a1

